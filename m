Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D03D29E1B
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 00:59:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0914CAC003
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 22:59:04 -0700 (PDT)
Received: from mail-qa0-f48.google.com (mail-qa0-f48.google.com
	[209.85.216.48]) by cuda.sgi.com with ESMTP id g43lwrAUD6L5KZMz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Aug 2013 22:59:03 -0700 (PDT)
Received: by mail-qa0-f48.google.com with SMTP id o19so828388qap.0
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 22:59:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130814053523.GY12779@dastard>
References: <1375260165-8773-1-git-send-email-zwu.kernel@gmail.com>
	<20130814053523.GY12779@dastard>
Date: Wed, 14 Aug 2013 13:59:02 +0800
Message-ID: <CAEH94LjeZHJ1uv7qCzVywq6rqkjisZ66+Y2+dXG64+Af6PXyEw@mail.gmail.com>
Subject: Re: [PATCH v3] xfs: introduce object readahead to log recovery
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>

On Wed, Aug 14, 2013 at 1:35 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jul 31, 2013 at 04:42:45PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   It can take a long time to run log recovery operation because it is
>> single threaded and is bound by read latency. We can find that it took
>> most of the time to wait for the read IO to occur, so if one object
>> readahead is introduced to log recovery, it will obviously reduce the
>> log recovery time.
>>
>> Log recovery time stat:
>>
>>           w/o this patch        w/ this patch
>>
>> real:        0m15.023s             0m7.802s
>> user:        0m0.001s              0m0.001s
>> sys:         0m0.246s              0m0.107s
>
> This version works as advertised as well.
>
>> @@ -3216,6 +3351,18 @@ xlog_recover_commit_trans(
>>                       goto out;
>>       }
>>
>> +     if (!list_empty(&ra_list)) {
>> +             error = xlog_recover_items_pass2(log, trans,
>> +                             &buffer_list, &ra_list);
>> +             if (error)
>> +                     goto out;
>> +
>> +             list_splice_tail_init(&ra_list, &done_list);
>> +     }
>> +
>> +     if (!list_empty(&done_list))
>> +             list_splice_init(&done_list, &trans->r_itemq);
>> +
>>       xlog_recover_free_trans(trans);
>
> I think this still leaks the trans structure when an error occurs.
> Indeed, I think this is a pre-existing leak, as the current code
> will skip freeing the trans structure on item recovery failure and
> nothing else frees it.  So it appears to me to be busted before this
> patch is added.
Yes, i also found this and think so.
>
> Hence on a xlog_recover_items_pass2() error we need to splice the
> ra-list to the done_list and free trans. i.e. the "if (error) goto
> out;" lines in the above hunk do not need to be there, and the
> "out:" label moved to above the call to xlog_recover_free_trans() so
> the main loop does the right thing when an error occurs.
Do you need to draft one patch to fix trans leaking? or can it be
fixed in this patch?
or will you draft one patch?

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
