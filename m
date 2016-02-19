Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F1D697C8C
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 12:43:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 01E2F8F8040
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 10:43:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id klrrHlOpa1DzVIJ3 for <xfs@oss.sgi.com>;
	Fri, 19 Feb 2016 10:43:14 -0800 (PST)
Subject: Re: [PATCH 1/3] quota: Add support for ->get_nextdqblk() for VFS quota
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
	<56C7518E.4020204@sandeen.net> <20160219183342.GH30068@quack.suse.cz>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56C76241.9020203@sandeen.net>
Date: Fri, 19 Feb 2016 12:43:13 -0600
MIME-Version: 1.0
In-Reply-To: <20160219183342.GH30068@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com



On 2/19/16 12:33 PM, Jan Kara wrote:
> On Fri 19-02-16 11:31:58, Eric Sandeen wrote:
>>
>>
>> On 2/4/16 8:28 AM, Jan Kara wrote:
>>> Add infrastructure for supporting get_nextdqblk() callback for VFS
>>> quotas. Translate the operation into a callback to appropriate
>>> filesystem and consequently to quota format callback.
>>>
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>> ---
>>>  fs/ext4/super.c          |  1 +
>>>  fs/quota/dquot.c         | 39 +++++++++++++++++++++++++++++++++++++++
>>>  fs/reiserfs/super.c      |  1 +
>>>  include/linux/quota.h    |  3 +++
>>>  include/linux/quotaops.h |  3 +++
>>>  5 files changed, 47 insertions(+)
>>>
>>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>>> index f1b56ff01208..51649f442bf6 100644
>>> --- a/fs/ext4/super.c
>>> +++ b/fs/ext4/super.c
>>> @@ -1100,6 +1100,7 @@ static const struct dquot_operations ext4_quota_operations = {
>>>  	.write_info	= ext4_write_info,
>>>  	.alloc_dquot	= dquot_alloc,
>>>  	.destroy_dquot	= dquot_destroy,
>>> +	.get_next_id	= dquot_get_next_id,
>>>  };
>>
>> Hi Jan, doesn't this also need to set:
>>
>>
>> +       .get_nextdqblk  = dquot_get_next_dqblk,
>>
>> in ext4_qctl_sysfile_operations?
> 
> Indeed, thanks for catching this. Patch added (with your authorship and
> sign-off) into my tree and this time I've properly tested Q_GETNEXTQUOTA
> for ext4 with quota in hidden inodes indeed works (previously I've tested
> only visible quota files).

Thanks Jan, I wasn't quite sure what it should be doing, but this seemed
right.  ;)  Sorry for not sending a proper patch.

So, when you tested visible quota files, I assume it was just falling
back to the non-next variants of the quotactl, right?  We should not
be hooking up the call for the visible quota files, right?

FWIW, there is a test in [x]fstests now for the [X]GETNEXT calls, it's
generic/244

Thanks!
-Eric

> 								Honza
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
