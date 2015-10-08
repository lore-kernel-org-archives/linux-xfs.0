Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4395A7F3F
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 03:34:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1BD2A304032
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 01:34:55 -0700 (PDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
	[209.85.212.169]) by cuda.sgi.com with ESMTP id
	tR0pmyI4z58RH0yH (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Oct 2015 01:34:53 -0700 (PDT)
Received: by wiclk2 with SMTP id lk2so17455281wic.0
	for <xfs@oss.sgi.com>; Thu, 08 Oct 2015 01:34:52 -0700 (PDT)
Date: Thu, 8 Oct 2015 11:34:49 +0300
From: Gleb Natapov <gleb@scylladb.com>
Subject: Re: Question about non asynchronous aio calls.
Message-ID: <20151008083449.GF11716@scylladb.com>
References: <20151007141833.GB11716@scylladb.com>
	<56152B0F.2040809@sandeen.net>
	<20151007150833.GB30191@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151007150833.GB30191@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Oct 07, 2015 at 11:08:34AM -0400, Brian Foster wrote:
> > > Second one is harder. We do need to write past the end of a file, actually
> > > most of our writes are like that, so it would have been great for XFS to
> > > handle this case asynchronously.
> > 
> > You didn't say what kernel you're on, but these:
> > 
> > 9862f62 xfs: allow appending aio writes
> > 7b7a866 direct-io: Implement generic deferred AIO completions
> > 
> > hit kernel v3.15.
> > 
> > However, we had a bug report about this, and Brian has sent a fix
> > which has not yet been merged, see:
> > 
> > [PATCH 1/2] xfs: always drain dio before extending aio write submission
> > 
> > on this list last week.
> > 
> > With those 3 patches, things should just work for you I think.
> > 
> 
> These fix some problems in that code, but the "beyond EOF" submission is
> still synchronous in nature by virtue of cycling the IOLOCK and draining
> pending dio. This is required to check for EOF zeroing, and we can't do
> that safely without a stable i_size.
> 
> Note that according to the commit Eric referenced above, ordering your
> I/O to always append (rather than start at some point beyond the current
> EOF) might be another option to avoid the synchronization here. Whether
> that is an option is specific to your application, of course.
> 
Our IO should be always append IIRC, the above explains why most aio we
do is truly async, but may be somewhere there is a reordering and then
we see synchronous behaviour. Will have to check it.

--
			Gleb.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
