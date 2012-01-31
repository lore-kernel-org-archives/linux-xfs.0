Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0V9RqqC235586 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 03:27:53 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7I9kMU93s8D8Pq8a (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 01:27:51 -0800 (PST)
Date: Tue, 31 Jan 2012 04:27:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS problem
Message-ID: <20120131092748.GA22999@infradead.org>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
	<20120124213936.GA1505@infradead.org>
	<CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
	<20120127105859.GC23335@infradead.org>
	<CAAA8XhOoF_AN_-1PsYQ+hp7adc08YuYqvA_3Bv9nqtuOzO1kOg@mail.gmail.com>
	<20120127191532.GA25529@infradead.org>
	<CAAA8XhMJeoUSMmcCizHqoFLrymbs7Hz216+7d445u6tV+ZC=fg@mail.gmail.com>
	<CAAA8XhPTnj+d1CzmpDvrYLRuZ3=p6A0sN1z-=yswezxA+MkF+A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAA8XhPTnj+d1CzmpDvrYLRuZ3=p6A0sN1z-=yswezxA+MkF+A@mail.gmail.com>
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
To: Kelbel Junior <jymmyjr@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jan 30, 2012 at 06:34:52PM -0200, Kelbel Junior wrote:
> How you prefer to pre allocate space?
> xfs I/O or by 'dd' to do it?
>
> What other information you would like to better understand and manage
> to solve this problem?

Do you expect to fill most of the file with data?  In that case
preallocating the file before starting I/O is the best way to do it.

>From the shell you can do it using the xfs_io 'resvsp' command, and
from C code using the fallocate system call, or if it's not present
the xfs RESVSP ioctl, as documented by the xfsctl manpage when
you have the xfsprogs development libraries installed.

If you actually want to keep the file sparse it's much harder.  You
could try larger I/O sized, or trying using the xfs extent size hint
which is set using the XFS_IOC_FSSETXATTR ioctl, again documented in
the xfsctl man page.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
