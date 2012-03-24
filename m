Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OH42Sn068138 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 12:04:03 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AvvGhTkDTDejzrut (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 10:04:02 -0700 (PDT)
Date: Sat, 24 Mar 2012 13:04:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LVM volume with XFS file system hanged
Message-ID: <20120324170401.GC21708@infradead.org>
References: <CANs4eSAs3B3qjMN=Z56-Y9HfXBsGNbJ_QD0hNmpYu8VcP-Ce8w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANs4eSAs3B3qjMN=Z56-Y9HfXBsGNbJ_QD0hNmpYu8VcP-Ce8w@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Supratik Goswami <supratiksekhar@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 23, 2012 at 02:19:05PM +0530, Supratik Goswami wrote:
> Hi
> 
> Our current system is running Ubuntu 10.04 with a the below kernel version.
> 
> root@ip-10-0-1-117:~# cat /etc/issue
> Ubuntu 10.04.4 LTS \n \l
> 
> root@ip-10-0-1-117:~# uname -a
> Linux ip-10-0-1-117 2.6.32-343-ec2 #45-Ubuntu SMP Tue Feb 14 18:18:17
> UTC 2012 x86_64 GNU/Linux
> 
> We have an LVM volume which is using XFS filesystem. We found the
> below call trace in /var/log/messages when it was unresponsive.
> 
> Can anyone please tell me what went wrong ?

Device mapper is hanging for some reason, and XFS waits for it to
finish.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
