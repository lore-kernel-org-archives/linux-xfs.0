Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Aug 2007 22:06:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7F56nbm027580
	for <xfs@oss.sgi.com>; Tue, 14 Aug 2007 22:06:51 -0700
Received: from Liberator.local (unknown [10.0.0.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id D24481806FDAE
	for <xfs@oss.sgi.com>; Wed, 15 Aug 2007 00:06:54 -0500 (CDT)
Message-ID: <46C289F4.1070502@sandeen.net>
Date: Wed, 15 Aug 2007 00:07:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] remove unused BULKSTAT_FG_INLINE
References: <46C27EF8.2020004@sandeen.net> <46C28571.2060206@sandeen.net>
In-Reply-To: <46C28571.2060206@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Eric Sandeen wrote:
> 
>> I was looking at xfs_bulkstat with an eye towards stack reduction,
>> and came across this... doesn't help stack, but it doesn't appear
>> that the BULKSTAT_FG_INLINE bulkstat is ever used... 
>>
>> Is it there for a reason?  If not here's a patch.

Ah hell.  dmapi uses it in cvs... drat, foiled again.  (there's also
some stack savings to be had by removing the private_data bulkstat
field... but dmapi uses that too)

-Eric
