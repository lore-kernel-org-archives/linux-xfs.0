Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8E4D7CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 19:12:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0759304032
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 17:12:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FpDRgBbUCWX1hzky for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 17:12:22 -0700 (PDT)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4031B16C154
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 19:12:22 -0500 (CDT)
Subject: Re: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-4-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5705A5E5.9060204@sandeen.net>
Date: Wed, 6 Apr 2016 19:12:21 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-4-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com

On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> @@ -1262,10 +1358,11 @@ main(
>  				switch (getsubopt(&p, (constpp)iopts, &value)) {
>  				case I_ALIGN:
>  					if (!value || *value == '\0')
> -						value = "1";
> -					iaflag = atoi(value);
> -					if (iaflag < 0 || iaflag > 1)
> +						reqval('i', iopts, I_ALIGN);
> +					c = atoi(value);
> +					if (c < 0 || c > 1)
>  						illegal(value, "i align");
> +					sb_feat.inode_align = c ? true : false;
>  					break;
>  				case I_LOG:
>  					if (!value || *value == '\0')


Hm, this seems wrong, as well - per the man page:

"If the value is omitted, 1 is assumed."

but this change with the reqval() removes that, doesn't it?  Why?
(it's fixed later, but there is no reason to break it mid-series...)

Before this patch:

# mkfs/mkfs.xfs -dfile,name=fsfile,size=1g -i align
meta-data=fsfile                 isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


After this patch:

# mkfs/mkfs.xfs -dfile,name=fsfile,size=1g -i align
-i align option requires a value
Usage: mkfs.xfs
/* blocksize */		[-b log=n|size=num]
/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx]
/* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,
			    (sunit=value,swidth=value|su=num,sw=num|noalign),
			    sectlog=n|sectsize=num
...


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
