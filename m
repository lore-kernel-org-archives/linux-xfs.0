Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RFrpjt216584 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 10:53:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
References: <87lih2h6i4.fsf@xmission.com> <87harqecvk.fsf@xmission.com>
	<20120827085034.GA8998@quack.suse.cz>
Date: Mon, 27 Aug 2012 08:54:21 -0700
In-Reply-To: <20120827085034.GA8998@quack.suse.cz> (Jan Kara's message of
	"Mon, 27 Aug 2012 10:50:34 +0200")
Message-ID: <87haro8h5e.fsf@xmission.com>
MIME-Version: 1.0
Subject: Re: [REVIEW][PATCH 13/15] userns: Add basic quota support
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Alex Elder <elder@kernel.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>, cluster-devel@redhat.com, Ben Myers <bpm@sgi.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, "Serge E. Hallyn" <serge@hallyn.com>

Jan Kara <jack@suse.cz> writes:

>   Hello,
>
> On Sat 25-08-12 17:05:35, Eric W. Biederman wrote:
>> Two helper are added dqgetusr and dqgetgrp to allow the quota
>> infrastructure to be called with a kuid and a kgid respectively.  This
>> creates type safe variants of dqget and leads to shorter more
>> comprehensible code.
>   It would look more comprehensible to me to have functions like:
> kuid2qown() and kgid2qown() and then call dqget(sb, kuid2qown(attr->uid))
> (see below for qown_t change proposal). The code then at the first look
> explains what is going on... Hmm?
>
>> Place the USRQUOTA and GRPQUOTA defines into enum quota_type.  This
>> brings with it the ability for the compiler to check that switch
>> statements handle every quota type, and the ability to mark which
>> values store the type of a quota entry.
>   OK, makes sense.
>
>> Add the data type qown_t a union of kuid_t and kgid_t. qown_t is a
>> replacement for the implicit union of uid and gid stored in an
>> unsigned int that is was used in the quota data structures.  Making
>> the data type explicit allows the kuid_t and kgid_t type safety to
>> propogate more thoroughly through the code, revealing more places
>> where uid/gid conversions need be made.
>   Hum, when we already do this, wouldn't it make more sense to embed quota
> type in qown_t? Because with the union thing you have no meaningful way of
> accessing that type without having quota type anyway. So having that in a
> single structure makes a lot of sense, plus it makes prototypes shorter...
> And you have to call make_qown() anyway...

So I think there was a reason for having the type separate but I'm not
seeing that reason off the top of my head.

I think it was filesystems like gfs2 doing weird things.  But I tell
you want I will play with this and if I can't reproduce find a reason
for putting them in one structure I will because there are definitely
good reasons for doing that.


>> Allong with the data type qown_t comes the helper functions
>> qown_eq, from_qown, from_qown_munged, qown_valid, and make_qown.
>> 
>> Update struct dquot dq_id to be a qown_t.
>> 
>> Update the signature of dqget, quota_send_warning, dquot_get_dqblk,
>> and dquot_set_dqblk to use enum quota_type and qown_t.
>> 
>> Make minimal changes to gfs2, ocfs2, and xfs to deal with the change
>> in quota structures and signatures.  The ocfs2 changes are larger than
>> most because of the extensive tracing throughout the ocfs2 quota code
>> that prints out dq_id.
>   Otherwise the changes look OK to me, although I didn't check them in
> detail yet (as above suggestions will change the code anyway).
>
> 								Honza

Thanks, 

Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
