Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 02:15:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S9F1XP008981
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:15:02 -0700
Received: from smtp.welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61A28550D04
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:15:00 -0700 (PDT)
Received: from smtp.welcomes-you.com (welcomes-you.com [85.214.50.128]) by cuda.sgi.com with ESMTP id G25mgDFhZOSzAkGp for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:15:00 -0700 (PDT)
Message-ID: <4906D80F.9050500@aei.mpg.de>
Date: Tue, 28 Oct 2008 10:14:55 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: Map a disk LBA to filename?
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com> <20081027233516.GG4985@disturbed> <4906BB32.8080403@aei.mpg.de> <20081028072105.GW4985@disturbed> <4906C164.6090704@aei.mpg.de>
In-Reply-To: <4906C164.6090704@aei.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com



Carsten Aulbert wrote:

> 
> Any idea where my logical error is?
> 

Related, more logical errors on my side probably:

Can someone give me a hint what I'm doing wrong here?

xfs_bmap -l  /local/boinc/time_stats_log
/local/boinc/time_stats_log:
        0: [0..127]: 280..407 128 blocks
        1: [128..159]: 728..759 32 blocks
        2: [160..167]: 1016..1023 8 blocks
        3: [168..183]: 54120..54135 16 blocks
        4: [184..207]: 656..679 24 blocks
        5: [208..215]: 3451664..3451671 8 blocks
        6: [216..255]: 3451624..3451663 40 blocks
        7: [256..287]: 3451672..3451703 32 blocks

>From that I assume that this file lives in several block strips, when I
subsequently try to get this back via xfs_db I fail miserably:

xfs_db -i /dev/sda6
xfs_db> blockget -b 660 -n
setting block 0/660 to data
setting inode to 2787 for block 0/660
inode 2787 block 660 at offset 346
xfs_db> ncheck -i 2787
       2787 CT_oneyear_01/S_noise_wu_84/Fstats_105.25_Snoise__WU84_84_out
xfs_db> quit

Is it possible that blocks != bsized_blocks?

Sorry for these questions, but I'm quite lost and I have not been able
to find the answer in the man pages.

Cheers

Carsten

-- 
Dr. Carsten Aulbert - Max Planck Institute for Gravitational Physics
Callinstrasse 38, 30167 Hannover, Germany
Phone/Fax: +49 511 762-17185 / -17193
http://www.top500.org/system/9234 | http://www.top500.org/connfam/6/list/31
