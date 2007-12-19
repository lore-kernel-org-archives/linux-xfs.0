Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 02:27:45 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBJARdWW024813
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 02:27:42 -0800
Received: from smtp-tls.univ-nantes.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24B2249D4EE
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 02:27:51 -0800 (PST)
Received: from smtp-tls.univ-nantes.fr (Smtp-Tls1.univ-nantes.fr [193.52.101.145]) by cuda.sgi.com with ESMTP id AOWnb5qDBw51Lxjz for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 02:27:51 -0800 (PST)
Message-ID: <4768F204.8060506@univ-nantes.fr>
Date: Wed, 19 Dec 2007 11:27:16 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: kernel oops on debian , 2.6.18-5
References: <476790D5.6040205@univ-nantes.fr> <20071218123259.GL4396912@sgi.com> <4767DC20.1080406@univ-nantes.fr> <op.t3j3221z3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t3j3221z3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Jacky Carimalo <jacky.carimalo@univ-nantes.fr>

Barry Naujok wrote:
>
>>
>> Can I stop the process and start another version without risking 
>> problems ?
>
> Yes, you can stop and restart. In your scenario, run xfs_repair -P to
> disable prefetch which is getting stuck.
>
> Barry.
>
>
>
Thanks for the tip, xfs_repair -P did the job.

Only minimal problems found :
(9856 K in lost+found for a 1 TB volume)

inchgower:/var/lib/vservers/VS_Archive/Archive/lost+found# ls -al
total 9860
drwxr-xr-x  2 root root        4096 2007-12-19 10:28 .
drwxr-xr-x 32 root root        4096 2007-12-04 16:26 ..
-rw-r-----  1 root root           0 2007-12-16 19:33 1311409765
-rwx------  1 root www-data    4992 2007-11-13 11:47 1388664851
-rwx------  1 root root        4643 2007-09-27 15:51 1388664852
-rw-------  1 ntp       104     369 2007-12-16 22:36 1624155084
-rw-r-----  1 root root           0 2007-12-16 22:03 17043457
-rw-r--r--  1 root root        8358 2005-05-10 21:54 1810860709
-rw-r--r--  1 root root        7644 2005-05-10 21:54 1818650492
-rw-r--r--  1 root root       45620 2005-05-10 21:54 1818650493
-rw-r--r--  1 root root        5304 2005-05-10 21:54 1818840419
-rw-r--r--  1 root root        5034 2005-05-10 21:54 1818841748
-rw-r--r--  1 root root        1300 2005-05-10 21:54 1818842113
-rw-r--r--  1 root root        6040 2005-05-10 21:54 1818842115
-rw-r--r--  1 root root        4008 2005-05-10 21:54 1818842134
-rw-r--r--  1 root root        4019 2005-05-10 21:54 1818873357
-rwx------  1 root www-data     732 2007-12-14 15:24 1900698499
-rw-r--r--  1 root root        1060 2007-02-21 18:48 2041002887
-rw-r--r--  1 root root         152 2005-11-10 17:09 2041002903
-rwx------  1 root www-data       0 2007-12-15 23:33 2153644053
-rwx------  1 root www-data       0 2007-12-15 23:33 2158002845
-rw-r--r--  1 root root       20480 2007-12-16 22:03 2572244357
drwxr-xr-x  2 root root          75 2007-12-16 23:27 268556858
drwxr-xr-x  2 root root           6 2007-12-16 23:27 268556859
-rw-r--r--  1 root root       20480 2007-12-16 19:33 273918729
-rw-r--r--  1 root root     1193201 2007-12-16 16:06 3223675010
-rw-r-----  1 root root           0 2007-12-16 19:33 3226075506
-rw-r--r--  1 root root       22451 2007-12-16 16:07 3226075507
-rwx------  1 root www-data   19211 2007-12-14 11:22 3361035798
-rwx------  1 root www-data    1265 2007-12-14 17:58 3628814835
-rwx------  1 root www-data       0 2007-12-15 22:00 3910289706
-rwx------  1 root www-data   19211 2007-12-14 13:57 4055379312
-rwx------  1 root www-data   14360 2007-12-14 17:58 4055415347
-rwx------  1 root www-data   14346 2007-12-10 18:01 4055415352
-rwx------  1 root www-data   19225 2007-12-14 17:58 4055415353
drwxr-xr-x  2 root root          19 2007-12-16 23:27 4160831758
drwxr-xr-x  2 root root          20 2007-12-16 23:27 4160831759
drwxr-xr-x  2 root root           6 2005-09-15 11:44 4160831760
-rw-r--r--  1 root root     1387921 2007-11-05 02:02 620696741
-rw-r--r--  1 root root     4715935 2007-11-06 02:02 620696742
-rw-r--r--  1 root root     1389488 2007-11-07 02:02 620696743
-rw-r--r--  1 root root     1193251 2007-12-16 20:49 633648296


as you can see, some entries on lost+found are from 2005-05-10
(we had some bad power fault at that time), so maybe the corruption was 
there since a very long time.

Cheers,


--
Yann Dupont, Cri de l'université de Nantes
Tel: 02.51.12.53.91 - Fax: 02.51.12.58.60 - Yann.Dupont@univ-nantes.fr
