Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 08:01:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VF0v2D010093
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 08:00:57 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D62DDB24FFD
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 08:00:58 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id GFFECrI4uABkPF2c for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 08:00:58 -0700 (PDT)
Message-ID: <490B1DA1.4030107@sandeen.net>
Date: Fri, 31 Oct 2008 10:00:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.25.18 in memory corruption?
References: <200810310858.07632.arekm@maven.pl>
In-Reply-To: <200810310858.07632.arekm@maven.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

Arkadiusz Miskiewicz wrote:
> Hi,
> 
> I'm trying to find out  a reason (and a solution) for in memory corruption with xfs involved.
> 
> Sometimes files are corrupted in such way as pasted below. This is in memory
> corruption since the file is correct after reboot. File size is unchanged as original,
> mtime not modified (compared to what I have in backup) according to ls -l.
> 
> There is no oops, just contents of some files (it happens like 1 file per week, well I notice
> one file per week) are partially trashed.
> 
> This is 230GB partition on lvm2, mounted with rw,nosuid,nodev,noatime,nodiratime,usrquota,grpquota
> options. Hardware is intel rack server (don't remember which one exactly) 1U with 2 x quad xeon,
> adaptec 3405, 4 SAS disks in raid5.
> 
> Any ideas what that could be?
> 
> /**
> * A class for reading Microsoft Excel Spreadsheets.
> *
> * Originally d4040\134040\134040\134040//"#,##0.00",^M\134012\134040\134040\134040\134040\134040\134040\134040\1340400x5\134040=>\134040"%1.0f",\134040\134040\134040\134040\134040/*"$#,##0;

Ow, my eyes ;)

try:

# hexdump -C $FILENAME

to see if it's obvious where the corruption boundaries are, or any
patterns that might be more readable than
"\134012\134040\134040\134040\134040\"  :)

-Eric
