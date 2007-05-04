Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 May 2007 23:57:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l446uwfB004955
	for <xfs@oss.sgi.com>; Thu, 3 May 2007 23:57:00 -0700
Date: Fri, 4 May 2007 02:56:26 -0400
From: Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070504065626.GW355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org> <20070504060731.GJ32602149@melbourne.sgi.com> <20070503232815.2f62a75e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503232815.2f62a75e.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>, David Chinner <dgc@sgi.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, May 03, 2007 at 11:28:15PM -0700, Andrew Morton wrote:
> > > The posix spec implies that negative `len' is permitted - presumably "allocate
> > > ahead of `offset'".  How peculiar.
> > 
> > I just checked the man page for posix_fallocate() and it says:
> > 
> >       EINVAL  offset or len was less than zero.

That describes the current glibc implementation.


> > We should probably follow this lead.
> 
> Yes, I think so.  I'm suspecting that
> http://www.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html
> is just buggy.  Or I can't read.
> 
> I mean, if we're going to support negative `len' then is the byte at
> `offset' inside or outside the segment?  Head spins.
> 
> However it would be neat if someone could test $OTHER_OS and, perhaps more
> importantly, the present glibc emulation (which I assume your manpage is
> referring to, so this would be a manpage test ;)).

int
posix_fallocate (int fd, __off_t offset, __off_t len)
{
  struct stat64 st;
  struct statfs f;

  /* `off_t' is a signed type.  Therefore we can determine whether
     OFFSET + LEN is too large if it is a negative value.  */
  if (offset < 0 || len < 0)
    return EINVAL;
  if (offset + len < 0)
    return EFBIG;

  /* First thing we have to make sure is that this is really a regular
     file.  */
  if (__fxstat64 (_STAT_VER, fd, &st) != 0)
    return EBADF;
  if (S_ISFIFO (st.st_mode))
    return ESPIPE;
  if (! S_ISREG (st.st_mode))
    return ENODEV;

  if (len == 0)
    {
      if (st.st_size < offset)
        {
          int ret = __ftruncate (fd, offset);

          if (ret != 0)
            ret = errno;
          return ret;
        }
      return 0;
    }
...

is what glibc does ATM.  Seems we violate the case where len == 0, as
EINVAL in that case is "shall fail".  But reading the standard to imply
negative len is ok is too much guessing, there is no word what it means
when len is negative and
"required storage for regular file data starting at offset and continuing for len bytes"
doesn't make sense for negative size.  
And given the general
"Implementations may support additional errors not included in this list,
may generate errors included in this list under circumstances other than
those described here, or may contain extensions or limitations that prevent
some errors from occurring."
I believe returning EINVAL for len < 0 is not a POSIX violation.
That doesn't mean the standard shouldn't be clarified, whether by saying
EINVAL must be returned for non-positive len or saying that using negative
len has undefined or implementation defined behavior.

> The above opengroup page only permits S_ISREG.  Preallocating directories
> sounds quite useful to me, although it's something which would be pretty
> hard to emulate if the FS doesn't support it.  And there's a decent case to
> be made for emulating it - run-anywhere reasons.  Does glibc emulation support
> directories?  Quite unlikely.

No, see above.

	Jakub
