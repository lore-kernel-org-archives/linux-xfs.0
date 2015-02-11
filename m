Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 274147F54
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 11:23:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 067E18F8054
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 09:23:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mwDkYpvcDVoAGDUw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Feb 2015 09:23:11 -0800 (PST)
Date: Wed, 11 Feb 2015 18:23:01 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: shared/032 is broken on Fedora
In-Reply-To: <54DB886D.9060201@sandeen.net>
Message-ID: <alpine.LFD.2.00.1502111759520.7269@localhost.localdomain>
References: <54DB35F0.1010203@plexistor.com> <54DB886D.9060201@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, 11 Feb 2015, Eric Sandeen wrote:

> Date: Wed, 11 Feb 2015 10:50:53 -0600
> From: Eric Sandeen <sandeen@sandeen.net>
> To: Boaz Harrosh <boaz@plexistor.com>, Dave Chinner <david@fromorbit.com>,
>     xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
>     fstests@vger.kernel.org
> Subject: Re: shared/032 is broken on Fedora
> 
> (cc: fstests list) 
> 
> On 2/11/15 4:58 AM, Boaz Harrosh wrote:
> > 
> > This is not the proper patch just to show a working version for Fedora. But I think
> > it now breaks the other ARCHs.
> > 
> > What happens is that the output of ${MKFS_PROG}.* is:
> > 	/usr/sbin/mkfs.bfs /usr/sbin/mkfs.btrfs /usr/sbin/mkfs.cramfs /usr/sbin/mkfs.ext2 /usr/sbin/mkfs.ext3 /usr/sbin/mkfs.ext4 ...
> > 
> > So in Fedora sbin has moved to /usr/... and therefor the sed below fails.
> > My sed foo is not good enough. How to support both places for sbin?
> 
> All we really want is the mkfs filesystem type, i.e. the ${FS} in mkfs.${FS}
> 
> So 
> 
> sed -e 's/.*mkfs.//g'
> 
> should work,
> 
> awk -F . '{print $NF}' would work too
> 
> $ cat mkfses 
> /usr/sbin/mkfs.ext4
> /sbin/mkfs.ext4
> 
> $ cat mkfses | awk -F . '{print $NF}'
> ext4
> ext4
> 
> $ cat mkfses | sed -e 's/.*mkfs.//g'
> ext4
> ext4
> 
> > Also why the "_supported_fs xfs btrfs"? So if all those other mkfs.* that are destructive to
> > foreign filesystem, should the test not fail instead of skipped?
> 
> mkfs.xfs & mkfs.btrfs are the only filesystems I know of which check for
> an existing format before proceeding, so they are the only ones
> tested.  Any other fs is skipped, because they are not designed to
> do what this test is... testing for.

First of all it's not only about other file system, but any common
signatures which the test is ignoring.

Moreover ext4 is looking for existing signatures, but will not complain
in case it's run without the console attached to it so it does not break
existing scripts.

> 
> > Maybe if the maintainers of all these filesystems day in and day out running xfstests and
> > see shared/032 failing, they might decide to fix their evil ways. Instead of skipping the
> > test and the said maintainer just ignores it?
> 
> I think it's just a design decision.  There's no actual requirement to warn about overwriting
> a format, so not doing so is not a failure or a bug, IMHO.

Exactly, also as I said above mkfs.extN is checking for signatures,
but at the same time we can not break scripts people has been using
for lifetime.

-Lukas

> 
> -Eric
> 
> > Thanks
> > Boaz
> > 
> > ---
> > diff --git a/tests/shared/032 b/tests/shared/032
> > index a410003..726e6b4 100755
> > --- a/tests/shared/032
> > +++ b/tests/shared/032
> > @@ -37,8 +37,8 @@ rm -f $seqres.full
> >  . ./common/filter
> >  
> >  # real QA test starts here
> > -_supported_fs xfs btrfs
> > +# _supported_fs xfs btrfs
> >  _supported_os Linux
> >  
> >  _require_scratch_nocheck
> >  _require_no_large_scratch_dev
> > @@ -49,8 +49,7 @@ if [ "$FSTYP" == "btrfs" ]; then
> >  		_notrun "Installed mkfs.btrfs does not support -f option"
> >  fi
> >  
> > -echo "Silence is golden."
> > -for fs in `echo ${MKFS_PROG}.* | sed -e 's/.sbin.mkfs.//g'`
> > +for fs in `echo ${MKFS_PROG}.* | sed -e 's/.usr\/sbin.mkfs.//g'`
> >  do
> >  	preop=""	# for special input needs
> >  	preargs=""	# for any special pre-device options
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
