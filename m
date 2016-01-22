Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 873547F37
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 07:57:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A6CB304032
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 05:57:22 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id PtZAkaFpNmBpCCs7 for <xfs@oss.sgi.com>;
	Fri, 22 Jan 2016 05:57:20 -0800 (PST)
Subject: Re: [PATCH 2/7] quota: add new quotactl Q_XGETNEXTQUOTA
References: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
	<1453435644-32261-3-git-send-email-sandeen@redhat.com>
	<20160122085549.GB16898@quack.suse.cz>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A2353F.4000400@sandeen.net>
Date: Fri, 22 Jan 2016 07:57:19 -0600
MIME-Version: 1.0
In-Reply-To: <20160122085549.GB16898@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com


On 1/22/16 2:55 AM, Jan Kara wrote:
> On Thu 21-01-16 22:07:19, Eric Sandeen wrote:
>> Q_XGETNEXTQUOTA is exactly like Q_XGETQUOTA, except that it
>> will return quota information for the id equal to or greater
>> than the id requested.  In other words, if the requested id has
>> no quota, the command will return quota information for the
>> next higher id which does have a quota set.  If no higher id
>> has an active quota, -ESRCH is returned.
>>
>> This allows filesystems to do efficient iteration in kernelspace,
>> much like extN filesystems do in userspace when asked to report
>> all active quotas.
>>
>> The patch adds a d_id field to struct qc_dqblk so that we can
>> pass back the id of the quota which was found, and return it
>> to userspace.
>>
>> Today, filesystems such as XFS require getpwent-style iterations,
>> and for systems which have i.e. LDAP backends, this can be very
>> slow, or even impossible if iteration is not allowed in the
>> configuration.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ...
>> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
>> index ea66670..4bf8d40 100644
>> --- a/fs/quota/quota.c
>> +++ b/fs/quota/quota.c
>> @@ -33,6 +33,7 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
>>  	/* allow to query information for dquots we "own" */
>>  	case Q_GETQUOTA:
>>  	case Q_XGETQUOTA:
>> +	case Q_XGETNEXTQUOTA:
> 
> IMO you should require CAP_SYS_ADMIN for the quotactl. Definitely doing the
> UID and GID checks for GETNEXTQUOTA looks strange to me since the returned
> structure may be for a different ID. Or did you assume that existing user
> will have quota structure allocated so we always return quotas for that ID
> in that case? I'm not sure this is good to rely on...

Oh whoops.  OK that was dumb of me, thanks for catching it.  No, I
didn't intend to rely on the asking user having a quota, it was
just a dumb mistake.  :)

>> +	ret = sb->s_qcop->get_nextdqblk(sb, qid, &qdq);
>> +	if (ret)
>> +	        return ret;
>> +	copy_to_xfs_dqblk(&fdq, &qdq, type, qdq.d_id);
>> +	if (copy_to_user(addr, &fdq, sizeof(fdq)))
>> +	        return -EFAULT;
>> +	return ret;
>> +}
> 
> So how about passing pointer to 'qid' to ->get_nextdqblk() and return the ID
> that way? That will also force you to fix the issue that you currently
> completely miss user-namespace conversions for the ID ;).

Ok.

> I definitely dislike mixing d_id in the qdq structure with arguments of fs
> callbacks and that d_id doesn't get filled for most callbacks. That is going
> to cause confusion.

Yeah, fair enough.  I'll change it.

Thanks,
-Eric

> 								Honza
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
