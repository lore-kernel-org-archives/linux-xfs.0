Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q115l1uF191345
	for <linux-xfs@oss.sgi.com>; Tue, 31 Jan 2012 23:47:01 -0600
Received: from snt0-omc1-s27.snt0.hotmail.com (snt0-omc1-s27.snt0.hotmail.com
	[65.55.90.38]) by cuda.sgi.com with ESMTP id QAEbDSLeDZFFfBfp
	for <linux-xfs@oss.sgi.com>; Tue, 31 Jan 2012 21:47:00 -0800 (PST)
Message-ID: <SNT135-W37050F210B8BE66ECC0A53A4730@phx.gbl>
From: yangguoquan <ygq51@hotmail.com>
Subject: RE: xfs: validate inode numbers in file handles correctly--NFS
	Stale File Handle Again
Date: Wed, 1 Feb 2012 13:46:58 +0800
In-Reply-To: <20120124175826.GA23671@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>,
	<loom.20111123T134243-580@post.gmane.org>,
	<20111123143045.GA20892@infradead.org>,
	<20111128111947.GA26454@infradead.org>,
	<SNT135-W2217EB3D3B80A8433A1FA4A4B70@phx.gbl>,
	<SNT135-W13E443B8D7BE73D5955314A4AD0@phx.gbl>,
	<20120102150201.GB31110@infradead.org>,
	<SNT135-W48F0EBD0BBCFF1CAFBF2BEA4970@phx.gbl>,
	<20120124175826.GA23671@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5715516555420097428=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org
Cc: linux-xfs@oss.sgi.com, pengxihan@gmail.com

--===============5715516555420097428==
Content-Type: multipart/alternative;
	boundary="_d46fa29a-a08b-4572-b36a-2122a86c8a82_"

--_d46fa29a-a08b-4572-b36a-2122a86c8a82_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit


The handles appear in wireshark is the same as in the /proc/net/rpc/nfsd.fh/content info
but there no corresponding directory path. just like this:
# * 6 0x06fd0000000000000000000000000000

root@Dahua_Storage:~# cat /proc/net/rpc/nfsd.fh/content 
#domain fsidtype fsid [path]
* 6 0x00fd0000000000000000000000000000 /mnt/storage_pool/testnfs00
* 6 0x03fd0000000000000000000000000000 /mnt/storage_pool/testnfs03
* 6 0x02fd0000000000000000000000000000 /mnt/storage_pool/testnfs02
* 6 0x01fd0000000000000000000000000000 /mnt/storage_pool/testnfs01
# * 6 0x06fd0000000000000000000000000000
* 6 0x05fd0000000000000000000000000000 /mnt/storage_pool/testnfs05
* 6 0x04fd0000000000000000000000000000 /mnt/storage_pool/testnfs04
# * 6 0x09fd0000000000000000000000000000
# * 6 0x08fd0000000000000000000000000000
# * 6 0x07fd0000000000000000000000000000
 
more info, this problem happens when rebooting the storage server while the nfs clients is still accessing the mounting points.


> Date: Tue, 24 Jan 2012 12:58:26 -0500
> From: hch@infradead.org
> To: ygq51@hotmail.com
> Subject: Re: xfs: validate inode numbers in file handles correctly--NFS Stale File Handle Again
> CC: hch@infradead.org; linux-xfs@oss.sgi.com; pengxihan@gmail.com
> 
> On Wed, Jan 04, 2012 at 10:20:31AM +0800, yangguoquan wrote:
> > 
> > Yes, They are mount points.
> > 
> > /dev/mapper/storage_pool-testnfs00 on /mnt/storage_pool/testnfs00 type xfs (rw)
> 
> In that case I really have no idea. Did you make sure you no
> outstanding "old" filehandles before the fix on clients? How do the
> handles look in wireshark traces?
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
 		 	   		  
--_d46fa29a-a08b-4572-b36a-2122a86c8a82_
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
<DIV dir=ltr>The&nbsp;handles appear in wireshark is&nbsp;the same as in the /proc/net/rpc/nfsd.fh/content info</DIV>
<DIV dir=ltr>but there no corresponding directory path. just like this:</DIV>
<DIV dir=ltr><FONT color=#ff0000># * 6 0x06fd0000000000000000000000000000</FONT><BR></DIV>
<DIV dir=ltr><A href="mailto:root@Dahua_Storage"><FONT color=#0068cf>root@Dahua_Storage</FONT></A>:~# cat /proc/net/rpc/nfsd.fh/content <BR>#domain fsidtype fsid [path]<BR>* 6 0x00fd0000000000000000000000000000 /mnt/storage_pool/testnfs00<BR>* 6 0x03fd0000000000000000000000000000 /mnt/storage_pool/testnfs03<BR>* 6 0x02fd0000000000000000000000000000 /mnt/storage_pool/testnfs02<BR>* 6 0x01fd0000000000000000000000000000 /mnt/storage_pool/testnfs01<BR># * 6 0x06fd0000000000000000000000000000<BR>* 6 0x05fd0000000000000000000000000000 /mnt/storage_pool/testnfs05<BR>* 6 0x04fd0000000000000000000000000000 /mnt/storage_pool/testnfs04<BR># * 6 0x09fd0000000000000000000000000000<BR># * 6 0x08fd0000000000000000000000000000<BR># * 6 0x07fd0000000000000000000000000000<BR>&nbsp;</DIV>
<DIV dir=ltr><FONT color=#ff0000>more info, this problem happens when rebooting the storage server while the nfs clients is still accessing the mounting points.</FONT><BR></DIV>
<DIV dir=ltr>
<DIV id=ecxSkyDrivePlaceholder></DIV>&gt; Date: Tue, 24 Jan 2012 12:58:26 -0500<BR>&gt; From: hch@infradead.org<BR>&gt; To: ygq51@hotmail.com<BR>&gt; Subject: Re: xfs: validate inode numbers in file handles correctly--NFS Stale File Handle Again<BR>&gt; CC: hch@infradead.org; linux-xfs@oss.sgi.com; pengxihan@gmail.com<BR>&gt; <BR>&gt; On Wed, Jan 04, 2012 at 10:20:31AM +0800, yangguoquan wrote:<BR>&gt; &gt; <BR>&gt; &gt; Yes, They are mount points.<BR>&gt; &gt; <BR>&gt; &gt; /dev/mapper/storage_pool-testnfs00 on /mnt/storage_pool/testnfs00 type xfs (rw)<BR>&gt; <BR>&gt; In that case I really have no idea. Did you make sure you no<BR>&gt; outstanding "old" filehandles before the fix on clients? How do the<BR>&gt; handles look in wireshark traces?<BR>&gt; <BR>&gt; _______________________________________________<BR>&gt; xfs mailing list<BR>&gt; xfs@oss.sgi.com<BR>&gt; http://oss.sgi.com/mailman/listinfo/xfs<BR></DIV> 		 	   		  </div></body>
</html>
--_d46fa29a-a08b-4572-b36a-2122a86c8a82_--


--===============5715516555420097428==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5715516555420097428==--
