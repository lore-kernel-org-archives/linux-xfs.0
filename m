Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751311AbdINCTc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Sep 2017 22:19:32 -0400
Date: Thu, 14 Sep 2017 11:19:30 +0900 (JST)
Message-Id: <20170914.111930.377047690261943710.yamato@redhat.com>
Subject: Re: [PATCH] xfs_repair: don't use do_warn for normal log message
From: Masatake YAMATO <yamato@redhat.com>
In-Reply-To: <20170913214821.GY17782@dastard>
References: <20170913104943.22034-1-yamato@redhat.com>
        <20170913214821.GY17782@dastard>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org

On Thu, 14 Sep 2017 07:48:21 +1000, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Sep 13, 2017 at 07:49:43PM +0900, Masatake YAMATO wrote:
>> In some case, exit statuses of xfs_repair -n are different even for the
>> same file system when -v is specified or not. This patch fixes this
>> behavior.
>> 
>> If -v is specified, do_warn() is used in zero_log() for printing
>> a normal message. That makes the exit status to 1 though there
>> is no dirtiness in the file system.
>> 
>> The original zero_log():
>> 
>> 	error = xlog_find_tail(log, &head_blk, &tail_blk);
>> 	if (error) {...
>> 	} else {
>> 		if (verbose) {
>> 			do_warn(
>> 	_("zero_log: head block %" PRId64 " tail block %" PRId64 "\n"),
>> 				head_blk, tail_blkn);
>> 		}
>> 
>> do_warn() is used for the message, "zero_log:...".  do_log
>> should be used instead because this log message is for just reporting the
>> values of head_blk, and tail_blk. do_log is for "just reporting".
>> 
>> Using do_warn unintentionally has an impact.
>> It causes the exit status of the command.
>> do_warn sets fs_is_dirty global variable.
>> That refers in main function to decide the exit status.
>> 
>>     void
>>     do_warn(char const *msg, ...)
>>     {
>> 	    va_list args;
>> 
>> 	    fs_is_dirty = 1;
>> 
>>     int
>>     main(int argc, char **argv)
>>     {
>>     ...
>> 
>> 		    if (fs_is_dirty)
>> 			    return(1);
>> ---
>>  repair/phase2.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/repair/phase2.c b/repair/phase2.c
>> index c21778b8..f7ea655f 100644
>> --- a/repair/phase2.c
>> +++ b/repair/phase2.c
>> @@ -75,7 +75,7 @@ zero_log(
>>  	 */
>>  	error = xlog_find_tail(log, &head_blk, &tail_blk);
>>  	if (error) {
>> -		do_warn(
>> +		do_log(
>>  		_("zero_log: cannot find log head/tail (xlog_find_tail=%d)\n"),
>>  			error);
>>  		if (!no_modify && !zap_log)
> 
> The code change doesn't match the code in commit description. This
> warning looks like a warning that needs to be issued and change the
> exist status - it indicates that there is a problem with the log.
> 
> Indeed, the commit description does not even need the code in it;
> reviewers are familiar with the difference between do_warn/do_log.
> What the commit message needs to do is explain when the problem
> occurs, what it's impact is and why it needs fixing. The code fix
> should then be obvious and self explanitory....

Thank you for comments.

How about [PATCH v2] I submited just after submitting
this [PATCH]?  I think the change in [PATCH v2] makes sense.
If the commit log in [PATCH v2] is not clear enough, I will submit
v3.

Regards,
Masatake YAMATO

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
