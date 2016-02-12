Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 014897CA2
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:06:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE7D08F8033
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 09:05:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1SwFPuhcEHPn1fIT for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2016 09:05:55 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8D1CF63C5FF0
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:05:55 -0600 (CST)
Subject: Re: [PATCH] xfs_quota: allow create limit when user or group names
	beginning with digits
References: <1449046955-8350-1-git-send-email-zlang@redhat.com>
	<565FBF9D.5010903@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BE10F3.8020307@sandeen.net>
Date: Fri, 12 Feb 2016 11:05:55 -0600
MIME-Version: 1.0
In-Reply-To: <565FBF9D.5010903@sandeen.net>
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
To: xfs@oss.sgi.com

Hi Dave, I think this one got missed.  Can you pick it up for next time?

Thanks,
-Eric

On 12/2/15 10:05 PM, Eric Sandeen wrote:
> I had to re-read the strtoul manpage (3 times) but yes, this looks right to
> me.
> 
> (technically it should probably check for overflow etc but I suppose that is
> outside the scope of this fix)
> 
> An xfstest would be good for this, although (as we discussed on IRC) I'm not
> sure if it is OK for xfstests to add users & groups - no other test does
> that today...
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> On 12/2/15 3:02 AM, Zorro Lang wrote:
>> A normal user or group name allow beginning with digits, but xfs_quota can't
>> create a limit for that user or group. The reason is 'strtoul' function only
>> translate digits at the beginning.
>>
>> There's a commit fd537fc50eeade63bbd2a66105f39d04a011a7f5, it try to fix
>> "xfsprogs: xfs_quota allow user or group names beginning with digits". But
>> it doesn't effect 'limit .... 12345678-user' command.
>>
>> Signed-off-by: Zorro Lang <zlang@redhat.com>
>> ---
>>
>> Hi Eric,
>>
>> This problem from a bug of ours, I have left message to you, please
>> help to check my simple patch. Thanks very much.
>>
>> Hi Rich,
>>
>> I don't understand why you fix commit fd537fc50eeade63bbd2a66105f39d04a011a7f5,
>> but didn't fix this. Or is this a feature, not a bug?
>>
>> I'm not so familiar with xfsprogs code, so if I'm wrong, please tell me;)
>>
>> Thanks,
>> Zorro
>>
>>  libxcmd/input.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/libxcmd/input.c b/libxcmd/input.c
>> index c505ab3..5a7dce3 100644
>> --- a/libxcmd/input.c
>> +++ b/libxcmd/input.c
>> @@ -366,7 +366,7 @@ uid_from_string(
>>  	char		*sp;
>>  
>>  	uid_long = strtoul(user, &sp, 10);
>> -	if (sp != user) {
>> +	if (sp != user && *sp == '\0') {
>>  		if ((uid_long == ULONG_MAX && errno == ERANGE)
>>  				|| (uid_long > (uid_t)-1))
>>  			return -1;
>> @@ -387,7 +387,7 @@ gid_from_string(
>>  	char		*sp;
>>  
>>  	gid_long = strtoul(group, &sp, 10);
>> -	if (sp != group) {
>> +	if (sp != group && *sp == '\0') {
>>  		if ((gid_long == ULONG_MAX && errno == ERANGE)
>>  				|| (gid_long > (gid_t)-1))
>>  			return -1;
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
