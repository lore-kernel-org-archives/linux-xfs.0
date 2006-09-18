Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 14:07:31 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8IL7OZd012221
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 14:07:25 -0700
Received: from agami.com ([192.168.168.132])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8IL6m2c011892
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 14:06:48 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8IL6hu0020382
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 14:06:43 -0700
Message-ID: <450F0A5E.4000208@agami.com>
Date: Tue, 19 Sep 2006 02:36:38 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: swidth with mdadm and RAID6
References: <Pine.LNX.4.10.10609181639000.1732-100000@limpet.umeoce.maine.edu>
In-Reply-To: <Pine.LNX.4.10.10609181639000.1732-100000@limpet.umeoce.maine.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: cousins@umit.maine.edu
Cc: "\"xfs@oss.sgi.com\" <xfs@oss.sgi.com>" <xfs@oss.sgi.com>

-shailendra

>Since I have a spare in there do you think it is starting with md.nr_disks
>= 11 and then subtracting two?
>  
>
You can verify that very quickly by removing the spare_disks option and see it gives proper results.

>Thanks,
>
>Steve
>______________________________________________________________________
> Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
> Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
> Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302
>
>On Mon, 18 Sep 2006, Shailendra Tripathi wrote:
>
>  
>
>>Hi Steve,
>>               Both of us are using old xfsprogs. It is handled in new 
>>xfsprogs. 
>>
>> */
>>		switch (md.level) {
>>		case 6:
>>			md.nr_disks--;
>>			/* fallthrough */
>>		case 5:
>>		case 4:
>>			md.nr_disks--;
>>			/* fallthrough */
>>		case 1:
>>		case 0:
>>		case 10:
>>			break;
>>		default:
>>			return 0;
>>
>>
>>Regards,
>>
>>Shailendra Tripathi wrote:
>>    
>>
