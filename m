Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q042KZl5108285
	for <linux-xfs@oss.sgi.com>; Tue, 3 Jan 2012 20:20:35 -0600
Received: from snt0-omc1-s22.snt0.hotmail.com (snt0-omc1-s22.snt0.hotmail.com
	[65.55.90.33]) by cuda.sgi.com with ESMTP id CZv8SWZ9g3Xcoyeo
	for <linux-xfs@oss.sgi.com>; Tue, 03 Jan 2012 18:20:33 -0800 (PST)
Message-ID: <SNT135-W48F0EBD0BBCFF1CAFBF2BEA4970@phx.gbl>
From: yangguoquan <ygq51@hotmail.com>
Subject: RE: xfs: validate inode numbers in file handles correctly--NFS
	Stale File Handle Again
Date: Wed, 4 Jan 2012 10:20:31 +0800
In-Reply-To: <20120102150201.GB31110@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>,
	<loom.20111123T134243-580@post.gmane.org>,
	<20111123143045.GA20892@infradead.org>,
	<20111128111947.GA26454@infradead.org>,
	<SNT135-W2217EB3D3B80A8433A1FA4A4B70@phx.gbl>,
	<SNT135-W13E443B8D7BE73D5955314A4AD0@phx.gbl>,
	<20120102150201.GB31110@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1428686061589492608=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org
Cc: linux-xfs@oss.sgi.com, pengxihan@gmail.com

--===============1428686061589492608==
Content-Type: multipart/alternative;
	boundary="_476c5d42-f273-4573-bc02-865d7a977ed1_"

--_476c5d42-f273-4573-bc02-865d7a977ed1_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit


Yes, They are mount points.
 
/dev/mapper/storage_pool-testnfs00 on /mnt/storage_pool/testnfs00 type xfs (rw)
/dev/mapper/storage_pool-testnfs01 on /mnt/storage_pool/testnfs01 type xfs (rw)
/dev/mapper/storage_pool-testnfs02 on /mnt/storage_pool/testnfs02 type xfs (rw)
/dev/mapper/storage_pool-testnfs03 on /mnt/storage_pool/testnfs03 type xfs (rw)
/dev/mapper/storage_pool-testnfs04 on /mnt/storage_pool/testnfs04 type xfs (rw)
/dev/mapper/storage_pool-testnfs05 on /mnt/storage_pool/testnfs05 type xfs (rw)
/dev/mapper/storage_pool-testnfs06 on /mnt/storage_pool/testnfs06 type xfs (rw)
/dev/mapper/storage_pool-testnfs07 on /mnt/storage_pool/testnfs07 type xfs (rw)
/dev/mapper/storage_pool-testnfs08 on /mnt/storage_pool/testnfs08 type xfs (rw)
/dev/mapper/storage_pool-testnfs09 on /mnt/storage_pool/testnfs09 type xfs (rw)
 

> Date: Mon, 2 Jan 2012 10:02:01 -0500
> From: hch@infradead.org
> To: ygq51@hotmail.com
> Subject: Re: xfs: validate inode numbers in file handles correctly--NFS Stale File Handle Again
> CC: hch@infradead.org; linux-xfs@oss.sgi.com; pengxihan@gmail.com
> 
> On Thu, Dec 29, 2011 at 05:19:55PM +0800, yangguoquan wrote:
> > 
> > NFS Stale File Handle Again, But this happens when mount operation not during accessing file or directory.
> > 
> > My /etc/exports file:
> > 
> > /mnt/storage_pool/testnfs00 *(rw,sync,no_root_squash)
> > /mnt/storage_pool/testnfs01 *(rw,sync,no_root_squash)
> > /mnt/storage_pool/testnfs02 *(rw,sync,no_root_squash)
> > /mnt/storage_pool/testnfs03 *(rw,sync,no_root_squash)
> > /mnt/storage_pool/testnfs04 *(rw,sync,no_root_squash)
> > /mnt/storage_pool/testnfs05 *(rw,sync,no_root_squash)
> > /mnt/storage_pool/testnfs06 *(rw,sync,no_root_squash)
> > /mnt/storage_pool/testnfs07 *(rw,sync,no_root_squash)
> > /mnt/storage_pool/testnfs08 *(rw,sync,no_root_squash)
> > /mnt/storage_pool/testnfs09 *(rw,sync,no_root_squash)
> 
> Are these mount points? If not take a look at
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_Why_doesn.27t_NFS-exporting_subdirectories_of_inode64-mounted_filesystem_work.3F
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
 		 	   		  
--_476c5d42-f273-4573-bc02-865d7a977ed1_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: 8bit

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
font-size: 10pt;
font-family:Î¢ÈíÑÅºÚ
}
--></style></head>
<body class='hmmessage'><div dir='ltr'>
Yes, They are mount points.<BR>
&nbsp;<BR>
/dev/mapper/storage_pool-testnfs00 on /mnt/storage_pool/testnfs00 type xfs (rw)<BR>/dev/mapper/storage_pool-testnfs01 on /mnt/storage_pool/testnfs01 type xfs (rw)<BR>
/dev/mapper/storage_pool-testnfs02 on /mnt/storage_pool/testnfs02 type xfs (rw)<BR>
/dev/mapper/storage_pool-testnfs03 on /mnt/storage_pool/testnfs03 type xfs (rw)<BR>
/dev/mapper/storage_pool-testnfs04 on /mnt/storage_pool/testnfs04 type xfs (rw)<BR>
/dev/mapper/storage_pool-testnfs05 on /mnt/storage_pool/testnfs05 type xfs (rw)<BR>
/dev/mapper/storage_pool-testnfs06 on /mnt/storage_pool/testnfs06 type xfs (rw)<BR>
/dev/mapper/storage_pool-testnfs07 on /mnt/storage_pool/testnfs07 type xfs (rw)<BR>
/dev/mapper/storage_pool-testnfs08 on /mnt/storage_pool/testnfs08 type xfs (rw)<BR>
/dev/mapper/storage_pool-testnfs09 on /mnt/storage_pool/testnfs09 type xfs (rw)<BR>
&nbsp;<BR>
<DIV>
<DIV id=SkyDrivePlaceholder></DIV>&gt; Date: Mon, 2 Jan 2012 10:02:01 -0500<BR>&gt; From: hch@infradead.org<BR>&gt; To: ygq51@hotmail.com<BR>&gt; Subject: Re: xfs: validate inode numbers in file handles correctly--NFS Stale File Handle Again<BR>&gt; CC: hch@infradead.org; linux-xfs@oss.sgi.com; pengxihan@gmail.com<BR>&gt; <BR>&gt; On Thu, Dec 29, 2011 at 05:19:55PM +0800, yangguoquan wrote:<BR>&gt; &gt; <BR>&gt; &gt; NFS Stale File Handle Again, But this happens when mount operation not during accessing file or directory.<BR>&gt; &gt; <BR>&gt; &gt; My /etc/exports file:<BR>&gt; &gt; <BR>&gt; &gt; /mnt/storage_pool/testnfs00 *(rw,sync,no_root_squash)<BR>&gt; &gt; /mnt/storage_pool/testnfs01 *(rw,sync,no_root_squash)<BR>&gt; &gt; /mnt/storage_pool/testnfs02 *(rw,sync,no_root_squash)<BR>&gt; &gt; /mnt/storage_pool/testnfs03 *(rw,sync,no_root_squash)<BR>&gt; &gt; /mnt/storage_pool/testnfs04 *(rw,sync,no_root_squash)<BR>&gt; &gt; /mnt/storage_pool/testnfs05 *(rw,sync,no_root_squas
 h)<BR>&gt; &gt; /mnt/storage_pool/testnfs06 *(rw,sync,no_root_squash)<BR>&gt; &gt; /mnt/storage_pool/testnfs07 *(rw,sync,no_root_squash)<BR>&gt; &gt; /mnt/storage_pool/testnfs08 *(rw,sync,no_root_squash)<BR>&gt; &gt; /mnt/storage_pool/testnfs09 *(rw,sync,no_root_squash)<BR>&gt; <BR>&gt; Are these mount points? If not take a look at<BR>&gt; <BR>&gt; http://xfs.org/index.php/XFS_FAQ#Q:_Why_doesn.27t_NFS-exporting_subdirectories_of_inode64-mounted_filesystem_work.3F<BR>&gt; <BR>&gt; _______________________________________________<BR>&gt; xfs mailing list<BR>&gt; xfs@oss.sgi.com<BR>&gt; http://oss.sgi.com/mailman/listinfo/xfs<BR></DIV> 		 	   		  </div></body>
</html>
--_476c5d42-f273-4573-bc02-865d7a977ed1_--


--===============1428686061589492608==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1428686061589492608==--
