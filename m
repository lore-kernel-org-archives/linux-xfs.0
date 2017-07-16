Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43454 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751230AbdGPC5O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 15 Jul 2017 22:57:14 -0400
Subject: Re: Collecting aged XFS profiles
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a40cd520-21cb-8c55-a38f-95d4519accbd@sandeen.net>
Date: Sat, 15 Jul 2017 21:57:13 -0500
MIME-Version: 1.0
In-Reply-To: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Saurabh Kadekodi <saukad@cs.cmu.edu>, linux-xfs@vger.kernel.org



On 07/15/2017 07:11 PM, Saurabh Kadekodi wrote:
> Hi,
> 
> I am a PhD student studying file and storage systems and I am currently conducting research on local file system aging. My research aims at understanding realistic aging patterns and analyzing the effects of aging on file system data structures and its performance. For this purpose, I would like to capture characteristics of naturally aged file systems (i.e. not aged via synthetic workload generators).
> 
> In order to facilitate this profile capture, I have written a shell / python based profiling tool (fsagestats - https://github.com/saurabhkadekodi/fsagestats)  that does a file system tree walk and captures different characteristics (file age, file size and directory depth) of files and directories and produces distributions. I do not care about file names or data within each file. It also runs xfs_db in order to capture the free space fragmentation, file fragmentation, directory fragmentation and overall fragmentation; all of which are directly correlated with the file system performance. It dumps the results in the results dir, which is to be specified when you run fsagestats. You can send me the aging profile by tarring up the results directory and sending it via email.
> 
> Since I do not have access to XFS systems that see a lot of churn, I am reaching out to the XFS community in order to find volunteers willing to run my script and capture their XFS aging profile. Please feel free to modify the script as per your installation or as you see fit. Since fsagestats collects no private information, I eventually intend to host these profiles publicly (unless explicitly requested not to) to aid other researchers / enthusiasts.

Just a note - 

Please see
http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F
before you put too much faith or emphasis in the frag number you get back ...

-Eric

> In case you have any questions on concerns, please let me know.
> 
> Thanks,
> Saurabh Kadekodi
