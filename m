Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 11 Nov 2006 02:58:50 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kABAwfaG024501
	for <xfs@oss.sgi.com>; Sat, 11 Nov 2006 02:58:42 -0800
Received: from emailer.gwdg.de (emailer.gwdg.de [134.76.10.24])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AD5A51737E
	for <xfs@oss.sgi.com>; Sat, 11 Nov 2006 02:57:44 -0800 (PST)
Date: Sat, 11 Nov 2006 11:55:53 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: XFS filesystem performance drop in kernels 2.6.16+
In-Reply-To: <20061110225257.63f91851.akpm@osdl.org>
Message-ID: <Pine.LNX.4.61.0611111153150.21326@yvahk01.tjqt.qr>
References: <bde600590611090930g3ab97aq3c76d7bca4ec267f@mail.gmail.com>
 <4553F3C6.2030807@sandeen.net> <Pine.LNX.4.61.0611101259490.6068@yvahk01.tjqt.qr>
 <bde600590611100516u7b8ca1bfs74d3cc8b78eb3520@mail.gmail.com>
 <20061110225257.63f91851.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: "Igor A. Valcov" <viaprog@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


>>     for (i = 0; i < 262144; i++) {
>>         /* Write data to a big file */
>>         write (nFiles [0], buf, __BYTES);
>> 
>>         /* Write data to small files */
>>         for (f = 1; f < __FILES; f++)
>>             write (nFiles [f], &f, sizeof (f));
>>     }
>
>This sits in a loop doing write(fd, buf, 4).  This is wildly inefficient -
>you'd get a 10x throughput benefit and maybe 100x reduction in CPU cost
>simply by switching to fwrite().

Well yes and no. The problem here is the syscall overhead. fwrite 
buffers things, so needless syscalls are avoided.
The same could be done by changing the program logic and increasing the 
size argument to read/write.

>I suspect something went wrong here.

Design error. :)


	-`J'
-- 
