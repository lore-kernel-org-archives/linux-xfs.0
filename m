Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 81D627CBF
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:08:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09C5CAC00F
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 03:08:00 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FirhsROEAAD5IJGV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 03:07:59 -0700 (PDT)
Message-ID: <51B1B0FB.4080701@oracle.com>
Date: Fri, 07 Jun 2013 18:07:55 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: How to Override Default inode64 mount option in openSUSE 12.3?
References: <1370597593.78403.YahooMailClassic@web192202.mail.sg3.yahoo.com>
In-Reply-To: <1370597593.78403.YahooMailClassic@web192202.mail.sg3.yahoo.com>
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
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: xfs@oss.sgi.com

Hello,

On 06/07/2013 05:33 PM, Gim Leong Chin wrote:

> Hi,
> 
> 
> I have just set up openSUSE 12.3 on my Acer notebook with a 750 GB WD hard drive, "/" with 80 GB and "/home" with 587 GB, both are XFS.
> 
> Both file systems are mounted with inode64 and no matter what I put in /etc/fstab, I am not able to remove inode64 option.
> 
> Is there any method to override the inode64 default mount option?

The inode64 mount option can be changed to inode32 via remount, e.g.
# mount -oremount,inode32 /storage_path

But I have no idea of the reason you facing now.

Thanks,
-Jeff

> 
> The reason I need to get rid of it is that acroread will not start, and I suspect that it is due to inode64, although I cannot confirm with strace on acroread.
> 
> Since the two file systems are under 1 TB, what is the point of inode64 any way?
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
