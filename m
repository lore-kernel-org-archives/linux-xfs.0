Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBOpA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 May 2019 10:45:00 -0400
Subject: Re: [PATCH V2] xfs: change some error-less functions to void types
References: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
 <2a52ea5e-e056-244b-4d9b-04ed15d996fd@sandeen.net>
 <20190502121741.GB22716@bfoster>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <c73c4e8f-dafb-d216-3af8-28bf1f1aac60@redhat.com>
Date: Thu, 2 May 2019 09:44:59 -0500
MIME-Version: 1.0
In-Reply-To: <20190502121741.GB22716@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 5/2/19 7:17 AM, Brian Foster wrote:
>> -	return 0;
>> +	return;
> No need for return statements at the end of void functions. With that
> fixed up (here and throughout the rest of the patch):
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 

Oh, hah.  IR smart.  (was on autopilot...)  I'll send V3.

-Eric
