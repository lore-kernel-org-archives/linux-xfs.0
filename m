Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44746 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751667AbdG1CSR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 22:18:17 -0400
Subject: Re: [PATCH 1/5 v2] mkfs: replace variables with opts table: -b,d,s
 options
References: <20170720095156.35417-2-jtulak@redhat.com>
 <20170721123448.6956-1-jtulak@redhat.com>
 <20170727163935.GL18884@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <08b84b1c-dbe9-8391-8c52-c7e7afbab27c@sandeen.net>
Date: Thu, 27 Jul 2017 21:18:16 -0500
MIME-Version: 1.0
In-Reply-To: <20170727163935.GL18884@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 7/27/17 11:39 AM, Luis R. Rodriguez wrote:
> On Fri, Jul 21, 2017 at 02:34:48PM +0200, Jan Tulak wrote:
>> @@ -1609,6 +1593,7 @@ main(
>>  			break;
>>  		case 'b':
>>  			p = optarg;
>> +			uint64_t tmp;
> Note:
> 
> An extra variable added, just so we can get the current value parsed
> so we can then convert it to also set similar collateral variables.

Also, please don't declare variables in the middle of code like this,
we generally stick to C89 rules.

Thanks,
-Eric
