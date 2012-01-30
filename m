Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0UEVd2V057718 for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 08:31:39 -0600
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id xVLFhD6zP6bBEzcz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Jan 2012 06:31:38 -0800 (PST)
Received: by lahd3 with SMTP id d3so2675741lah.26
	for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 06:31:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120127191532.GA25529@infradead.org>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
	<20120124213936.GA1505@infradead.org>
	<CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
	<20120127105859.GC23335@infradead.org>
	<CAAA8XhOoF_AN_-1PsYQ+hp7adc08YuYqvA_3Bv9nqtuOzO1kOg@mail.gmail.com>
	<20120127191532.GA25529@infradead.org>
Date: Mon, 30 Jan 2012 12:31:36 -0200
Message-ID: <CAAA8XhMJeoUSMmcCizHqoFLrymbs7Hz216+7d445u6tV+ZC=fg@mail.gmail.com>
Subject: Re: XFS problem
From: Kelbel Junior <jymmyjr@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi, Christoph.

Yes, we work on 1TB file, doing lots of random I/O over a single file.
We are using 'pwrite' ofr each write operation.

Output of 'filefrag' in this file:
file: 1364 extents found

The 'mount' options are the same as mentioned earlier.
About RAID, we use RAID 0.

In a file with this size and this extents amount could happen the
problem that we're seeing?


Thanks.
Kelbel Junior

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
