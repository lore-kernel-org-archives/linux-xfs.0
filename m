Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B28957F69
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 23:46:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 922708F8039
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 21:46:45 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id EVIbSwpajSwK7fk9 (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 21:46:44 -0800 (PST)
Received: from epcpsbgr1.samsung.com
	(u141.gpu120.samsung.co.kr [203.254.230.141])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NHS004N7LDUD0A0@mailout4.samsung.com> for
	xfs@oss.sgi.com; Wed, 07 Jan 2015 14:46:42 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <003f01d02670$27a5e300$76f1a900$@samsung.com>
	<20150106163220.GE5874@bfoster.bfoster>
In-reply-to: <20150106163220.GE5874@bfoster.bfoster>
Subject: RE: [PATCH v7 1/11] fs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Date: Wed, 07 Jan 2015 14:46:41 +0900
Message-id: <001701d02a3d$502c5a40$f0850ec0$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Brian Foster' <bfoster@redhat.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>

> On Fri, Jan 02, 2015 at 06:40:33PM +0900, Namjae Jeon wrote:
> > FALLOC_FL_INSERT_RANGE command is the opposite command of
> > FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
> > add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
> > for writing new data within a file after shifting extents to right as given
> > length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
> > that is block boundary and use ftruncate(2) for crosses EOF.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  fs/open.c                   |  8 +++++++-
> >  include/uapi/linux/falloc.h | 15 +++++++++++++++
> >  2 files changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/open.c b/fs/open.c
> > index 36662d0..74ed498 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -232,7 +232,8 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >
> >  	/* Return error if mode is not supported */
> >  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> > -		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
> > +		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
> > +		     FALLOC_FL_INSERT_RANGE))
> >  		return -EOPNOTSUPP;
> >
> >  	/* Punch hole and zero range are mutually exclusive */
> > @@ -250,6 +251,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >  	    (mode & ~FALLOC_FL_COLLAPSE_RANGE))
> >  		return -EINVAL;
> >
> > +	/* Insert range should only be used exclusively. */
> > +	if ((mode & FALLOC_FL_INSERT_RANGE) &&
> > +	    (mode & ~FALLOC_FL_INSERT_RANGE))
> > +		return -EINVAL;
> > +
> >  	if (!(file->f_mode & FMODE_WRITE))
> >  		return -EBADF;
> >
> > diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> > index d1197ae..1f20723 100644
> > --- a/include/uapi/linux/falloc.h
> > +++ b/include/uapi/linux/falloc.h
> > @@ -41,4 +41,19 @@
> >   */
> >  #define FALLOC_FL_ZERO_RANGE		0x10
> >
> > +/*
> > + * FALLOC_FL_INSERT_RANGE is use to insert space within the file size without
> 
> 				used
> 
> > + * overwriting any existing data. The contents of the file beyond offset are
> > + * shifted towards right by len bytes to create a hole.  As such, this
> > + * operation will increase the size of the file by len bytes.
> 
> I suppose we should split this comment up into a few paragraphs similar
> to the collapse range comment it is based on. That means we split
> here...
> 
> > + * Different filesystems may implement different limitations on the granularity
> > + * of the operation. Most will limit operations to filesystem block size
> > + * boundaries, but this boundary may be larger or smaller depending on
> > + * the filesystem and/or the configuration of the filesystem or file.
> 
> ... and here.
> 
> Otherwise this looks fine to me.
Okay, I will fix them.
> 
> Brian
> 
> > + * Attempting to insert space using this flag at OR beyond the end of
> > + * the file is considered an illegal operation - just use ftruncate(2) or
> > + * fallocate(2) with mode 0 for such type of operations.
> > + */
> > +#define FALLOC_FL_INSERT_RANGE		0x20
> > +
> >  #endif /* _UAPI_FALLOC_H_ */
> > --
> > 1.7.11-rc0
> >

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
