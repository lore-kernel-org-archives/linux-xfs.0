Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBB367F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 12:35:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C31418F804B
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:35:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GNPUkF7EV3MK8vld for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 10:35:37 -0700 (PDT)
Message-ID: <5245C1E8.2030107@sandeen.net>
Date: Fri, 27 Sep 2013 12:35:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix memory leak in xlog_recover_add_to_trans
References: <20130927140104.515578025@sgi.com> <5245B86F.3030309@sandeen.net>
	<5245C195.1080704@sgi.com>
In-Reply-To: <5245C195.1080704@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 9/27/13 12:34 PM, Mark Tinguely wrote:
> On 09/27/13 11:55, Eric Sandeen wrote:
>> On 9/27/13 9:00 AM, tinguely@sgi.com wrote:
>>> Free the memory in error path of xlog_recover_add_to_trans().
>>> Normally this memory is freed in recovery pass2, but is leaked
>>> in the error path.
>>>
>>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>
>> For this local leak & the fix,
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>> Since this gets called in a loop from xlog_recover_process_data(),
>> I'm wondering what happens to previously-allocated items, if we
>> return an error and never get to pass2?
>>
>> (I could be off base, haven't really followed it through, but
>> it seems like they might leak).
>>
>> Thanks,
>> -Eric
> 
> yeah you are correct, it looks like it gets leaked.
> I will add it to the list.

Thanks.  I suppose maybe if it's cleaned up at a higher level,
it doesn't need to be done here, but (*shrug*) I'll let you work
that out.  :)

-Eric

> Thanks.
> 
> --Mark.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
