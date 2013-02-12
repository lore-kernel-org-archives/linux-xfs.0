Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 23AED7FA2
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 05:58:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E56E68F8033
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 03:58:50 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p4wQyZCxZ8PCfJUJ for
	<xfs@oss.sgi.com>; Tue, 12 Feb 2013 03:58:50 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1CBwnfD007808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 06:58:49 -0500
Date: Tue, 12 Feb 2013 12:58:46 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
In-Reply-To: <20130212113152.GH20408@x2.net.home>
Message-ID: <alpine.LFD.2.00.1302121258350.2315@(none)>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
	<20130212113152.GH20408@x2.net.home>
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
To: Karel Zak <kzak@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>, sandeen@redhat.com, xfs@oss.sgi.com

On Tue, 12 Feb 2013, Karel Zak wrote:

> Date: Tue, 12 Feb 2013 12:31:52 +0100
> From: Karel Zak <kzak@redhat.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com, sandeen@redhat.com
> Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
> 
> On Tue, Feb 12, 2013 at 12:06:55PM +0100, Lukas Czerner wrote:
> > +wipe_signatures(
> > +	char		*device,
> > +	int		dryrun)
> > +{
> > +	blkid_probe	pr = NULL;
> > +	int		ret = 0;
> > +	int		fd;
> > +
> > +	pr = blkid_new_probe_from_filename(device);
> > +	if (!pr)
> > +		goto out;
> > +
> > +	fd = open(device, O_RDWR|O_CLOEXEC);
> > +	if (fd < 0) {
> > +		ret = -1;
> > +		goto out;
> > +	}
> > +	ret = blkid_probe_set_device(pr, fd, 0, 0);
> 
>  This does not make sense. The blkid_new_probe_from_filename() also
>  opens (read-only) the device ;-)

Good to know thanks!

-Lukas

> 
>  You need:
> 
>    pr = blkid_new_probe();
>    if (!pr)
>       goto out;
> 
>    fd = open(device, O_RDWR|O_CLOEXEC);
>    if (fd < 0) {
> 		ret = -1;
> 		goto out;
>    }
>    ret = blkid_probe_set_device(pr, fd, 0, 0);
> 
> 
>  Maybe you also need something like
>  
>    AC_CHECK_LIB(blkid, blkid_do_wipe, [have_blkidwipe=yes], [have_blkidwipe=no])
> 
>  or so, because old libblkid versions does not contain wipe stuff. See also
>  m4/package_blkid.m4 in xfsprogs where is already check for blkid topology
>  stuff.
> 
> 
>  Karel
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
