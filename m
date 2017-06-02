Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41140 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751120AbdFBDei (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 23:34:38 -0400
Subject: Re: [sparc64] crc32c misbehave
References: <20170601.174419.2151404855471358626.davem@davemloft.net>
 <20170601.215711.1719799806113363582.davem@davemloft.net>
 <9902b59c-0f73-f306-28e0-fea7ee4a1169@sandeen.net>
 <20170601.233329.698047529665811283.davem@davemloft.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a4400f52-5b16-4cd5-1067-9984e8d21dc6@sandeen.net>
Date: Thu, 1 Jun 2017 22:34:37 -0500
MIME-Version: 1.0
In-Reply-To: <20170601.233329.698047529665811283.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Miller <davem@davemloft.net>
Cc: matorola@gmail.com, sparclinux@vger.kernel.org, linux-xfs@vger.kernel.org



On 6/1/17 10:33 PM, David Miller wrote:
> From: Eric Sandeen <sandeen@sandeen.net>
> Date: Thu, 1 Jun 2017 21:10:50 -0500
> 
>> On ARM, there was a gcc bug causing similar results - I /think/
>> it was https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63293
>>
>> "programs could fail sporadically with this if an interrupt happens at
>> the wrong instant in time and data was written onto the current stack."
>>
>> https://gcc.gnu.org/ml/gcc-patches/2014-09/msg02292.html
>>
>> Maybe totally unrelated; if not, hope it helps.  :)
> 
> Wow, that looks exactly like what the bug is:

Sweet.

\o/

-Eric
