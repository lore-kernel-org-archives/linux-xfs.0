Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 27 Oct 2007 04:48:57 -0700 (PDT)
Received: from smtp-out.neti.ee (mail.neti.ee [194.126.101.114])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9RBmo9l018107
	for <xfs@oss.sgi.com>; Sat, 27 Oct 2007 04:48:52 -0700
Received: from smtp-out.neti.ee (relay13.estpak.ee [88.196.174.168])
	by HOT-Bounce1.estpak.ee (Postfix) with ESMTP id 2235E6C41F4
	for <xfs@oss.sgi.com>; Sat, 27 Oct 2007 14:30:38 +0300 (EEST)
In-Reply-To: <20071019075949.GS995458@sgi.com>
References: <B4D42128-E5B2-48B1-AEF1-586FD90AF605@cern.ch> <20071018222357.GN995458@sgi.com> <F9DEBD65-7751-4187-97EF-1DF1F63B0888@cern.ch> <20071019075949.GS995458@sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <034B199C-F1D2-42F8-B774-58AA11D8C79E@cern.ch>
Content-Transfer-Encoding: 7bit
From: Mario Kadastik <mario.kadastik@cern.ch>
Subject: Re: raw vs XFS sequential write and system load
Date: Sat, 27 Oct 2007 14:30:32 +0300
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Well to finally summarize, the things pointed out all helped too, but  
the major change in system behavior came from the fact that 2.6.23  
had totally different virtual memory defaults than 2.6.9 and running  
with 2.6.23 one has to change the dirty_ratio to something bigger to  
allow for a fast i/o machine to actually handle the load. Now the  
four nodes we have are all running very nicely and calmly and  
performing all the tasks we have asked from them, no more see we any  
congestion etc.

I have summarized my weeks of investigations into a twiki page,  
comments are welcome:

http://hep.kbfi.ee/index.php/IT/KernelTuning

Thanks for the help,

Mario
