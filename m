Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Oct 2006 01:35:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9D8Z2aG008341
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 01:35:05 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78B93D1946AA
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 01:34:19 -0700 (PDT)
Received: from agami.com ([192.168.168.127])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k9D8YI3l029920
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 01:34:18 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k9D8YDaB005917
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 01:34:13 -0700
Message-ID: <452F4EDF.6010500@agami.com>
Date: Fri, 13 Oct 2006 14:01:27 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: Data type overflow in xfs_trans_unreserve_and_mod_sb
References: <55EF1E5D5804A542A6CA37E446DDC206655888@mapibe17.exchange.xchg> <45179573.3020007@agami.com> <20061011052557.GM19345@melbourne.sgi.com> <20061013061354.GF19345@melbourne.sgi.com>
In-Reply-To: <20061013061354.GF19345@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: sandeen@sandeen.net, xfs@oss.sgi.com, Timothy Shimmin <tes@sgi.com>



David Chinner wrote:
>>Eric, you suggested specific 64 bit types - I think that's really the
>>way to fix this, but it's a much bigger change...
> 
> 
> Shailendra, here's a patch that passes XFSQA that changes this all to 64 bit
> types.  I've had to fix various type abuses that weren't obvious because gcc
> fails to warn when you pass a uint into a function parameter that is declared
> as int64_t.....
> 
> I haven't tested the >2TB grow case yet, but it should work now 
> on both 32bit and 64 bit platforms with this patch.
> 
> Is there anything I missed here in the conversion?
> 
> Cheers,
> 
> Dave.

Looks ok to me, Dave.
Thanks.
