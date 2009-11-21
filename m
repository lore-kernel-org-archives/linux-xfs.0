Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nALHXHBx042248 for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 11:33:18 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id EA4D21C01663
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 09:33:40 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id iySKKehWxn8jcpNu for <xfs@oss.sgi.com>;
	Sat, 21 Nov 2009 09:33:40 -0800 (PST)
From: Juergen Urban <JuergenUrban@gmx.de>
Subject: Re: BUG() in end_page_writeback(),
	stack overflows and system speed decrease with XFS over USB
Date: Sat, 21 Nov 2009 18:33:20 +0100
References: <200911190957.45957.JuergenUrban@gmx.de>
	<200911210200.13438.JuergenUrban@gmx.de>
	<200911211151.23764@zmi.at>
In-Reply-To: <200911211151.23764@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911211833.20691.JuergenUrban@gmx.de>
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
To: xfs@oss.sgi.com

On Saturday 21 November 2009 11:51:23 Michael Monnerie wrote:
> On Samstag, 21. November 2009 Juergen Urban wrote:
> > To get the error I just need to play video with mplayer and don't
> > need to write to the file system at all.
>
> This really sounds like a broken hardware. Have you tried running
> MEMTEST?
>
> mfg zmi

At the first moment I also thought that it is a hardware bug. I already ran 
MEMTEST for some hours, but it doesn't find anything. I replaced the main 
board, the CPU and the power supply. I also tried to replace/remove RAM. But 
I've done this while chasing for the stack overflow. But maybe this a problem 
which I introduced by replacing the hardware. So I will try to change all the 
hardware back.
Can someone explain the purpose of the BUG() in end_page_writeback()? Can I 
remove the line?
Will XFS also work if I disable all address operations? What is the purpose of 
the address operations?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
