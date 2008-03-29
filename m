Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Mar 2008 09:44:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2TGicY0006670
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 09:44:39 -0700
Received: from drutsystem.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11D5D708BD9
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 09:45:09 -0700 (PDT)
Received: from drutsystem.com (drutsystem.com [80.72.38.138]) by cuda.sgi.com with ESMTP id WH7MgI8V5SztFHCB for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 09:45:09 -0700 (PDT)
Received: from drutsystem.com (localhost.drutsystem.com [127.0.0.1])
	by drutsystem.com (Postfix) with ESMTP id 3B21D9480FE
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 16:27:19 +0000 (GMT)
Received: from [10.0.0.2] (87-205-36-149.adsl.inetia.pl [87.205.36.149])
	by drutsystem.com (Postfix) with ESMTP id E06839480FD
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 17:27:18 +0100 (CET)
Message-ID: <47EE6DE2.1010800@drutsystem.com>
Date: Sat, 29 Mar 2008 17:27:14 +0100
From: Michal Soltys <nozo@drutsystem.com>
MIME-Version: 1.0
Subject: Re: XFS performance on LVM2 mirror
References: <1206481052.4283.17.camel@dhcp-192-168-6-143>
In-Reply-To: <1206481052.4283.17.camel@dhcp-192-168-6-143>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Scott Tanner wrote:
> Hello,
>   I've been doing some benchmarking (using bonnie++) of the XFS
> filesystem and found a substantial performance drop in rewrite and
> delete operations when using an LVM2 mirror. When using the Linux
> Software Raid driver to perform the mirror, XFS performance is quite
> good. I've tried a number of the performance tweaks from the mailing
> list archives, as seen below. The only option that seemed to make a real
> difference was LVM's --corelog, which only worked for 1 test then the
> server crashed. 
> 
> Are there any special tweaks for XFS on LVM2 mirrors? Recommendations on
> my setup?
> 

Recently - there have been plenty of topics on linux-raid mailing list
regarding this subject as well - worth checking them out.

Generally important things to consider - read-ahead on your lv volume
(or md device in case where xfs is directly on it - r-a of components
are not used then), alignment of logical volumes with respect to
underlying raid (especially as you use 128k chunk and by default volume
won't start at multiple of 128k), lv extent size, xfs su/sw parameters
which you will have to set manually, if you are on lvm on md raid.
