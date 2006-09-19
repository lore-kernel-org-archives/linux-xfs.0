Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Sep 2006 09:59:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8JGx0aG007093
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 09:59:01 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76E44457987
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 09:58:22 -0700 (PDT)
Received: from agami.com ([192.168.168.132])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8JGwH2c023378
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 09:58:21 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8JGwC9v002380
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 09:58:12 -0700
Message-ID: <451021C0.8040701@agami.com>
Date: Tue, 19 Sep 2006 22:28:40 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: swidth with mdadm and RAID6
References: <Pine.LNX.4.10.10609191233310.2460-100000@limpet.umeoce.maine.edu>
In-Reply-To: <Pine.LNX.4.10.10609191233310.2460-100000@limpet.umeoce.maine.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: cousins@umit.maine.edu
Cc: xfs@oss.sgi.com

> Hi Shailendra,
> 
> I ran the program and it reports:
> 
> 	Level 6, disks=11 spare_disks=1 raid_disks=10
> 
> which looks good.   I don't understand why you got:
> 
> 	Level 5, disks=7 spare_disks=3 raid_disks=5
> 
> Why would it have 3 spare_disks?

Perhaps you are running more recent kernel than mine, and, spare_disks 
now reports only actual spares. It did appear little weired that it 
reported spare_disks as 3. get_array_info is changed in recent kernels 
and that should explain this difference.
