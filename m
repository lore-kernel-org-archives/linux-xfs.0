Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 23:45:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8J6isaG014364
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 23:44:55 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90006D177233
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 23:44:14 -0700 (PDT)
Received: from agami.com ([192.168.168.132])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8J6iE2c017899
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 23:44:14 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8J6i9Ao027803
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 23:44:09 -0700
Message-ID: <450F91D4.1030606@agami.com>
Date: Tue, 19 Sep 2006 12:14:36 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: swidth with mdadm and RAID6
References: <Pine.LNX.4.10.10609181639000.1732-100000@limpet.umeoce.maine.edu> <450F1A1F.1020204@agami.com> <450F7C1E.5020300@sgi.com>
In-Reply-To: <450F7C1E.5020300@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: cousins@umit.maine.edu, "\"xfs@oss.sgi.com\" <xfs@oss.sgi.com>" <xfs@oss.sgi.com>


Hi Tim,

> I'm not that au fait with RAID and md, but looking at what you wrote,
> Shailendra, and the md code, instead of your suggestions
> (what I think are your suggestions:) of:
> 
> (1) subtracting parity from md.raid_disk (instead of md.nr_disks)
>     where we work out parity by switching on md.level
> or
> (2) using directly: (md.nr_disks - md.spares);
> 
> that instead we could use:
> (3) using directly:  md.active_disks
> 
> i.e.
> *swidth = *sunit * md.active_disks;
> I presume that active is the working non spares and non-parity.
> 
> Does that make sense?
       I agree with you that for operational raid since there would not 
be any faulty disks, active disks should the number of disks. However, I 
am just concerned that active disks tracks live disks (not failed 
disks). If we ever used these commands when the system has faulty drive, 
the information returned wouldn't be correct. Though, from XFS 
perspective, I can't think of where it can happen.
       I would still say that lets rely more on raid_disks to be more 
conservative, just my choice.
