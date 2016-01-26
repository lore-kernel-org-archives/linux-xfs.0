Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC08F7CA2
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 11:57:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA8D2304032
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 09:57:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RHiOoMGpEykbIb6I (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2016 09:57:12 -0800 (PST)
Subject: Re: [PATCH 2/7] quota: add new quotactl Q_XGETNEXTQUOTA
References: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
	<1453487136-12681-3-git-send-email-sandeen@redhat.com>
	<20160126125710.GA23820@quack.suse.cz> <56A78A09.5080307@redhat.com>
	<20160126175205.GA29388@quack.suse.cz>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <56A7B375.3000304@redhat.com>
Date: Tue, 26 Jan 2016 11:57:09 -0600
MIME-Version: 1.0
In-Reply-To: <20160126175205.GA29388@quack.suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 1/26/16 11:52 AM, Jan Kara wrote:
> On Tue 26-01-16 09:00:25, Eric Sandeen wrote:
>> On 1/26/16 6:57 AM, Jan Kara wrote:
>>> On Fri 22-01-16 12:25:31, Eric Sandeen wrote:
>>>> Q_XGETNEXTQUOTA is exactly like Q_XGETQUOTA, except that it
>>>> will return quota information for the id equal to or greater
>>>> than the id requested.  In other words, if the requested id has
>>>> no quota, the command will return quota information for the
>>>> next higher id which does have a quota set.  If no higher id
>>>> has an active quota, -ESRCH is returned.
>>>
>>> Actually, is -ESRCH the right return value? It seems XFS traditionally
>>> returns -ENOENT when id doesn't exist. So that would look more logical to
>>> me.
>>
>> Hm, I was just going by the quotactl manpage, TBH, which says:
>>
>>        ESRCH          No disc quota is found for the indicated user.
>>
>>
>> But yes, you are right, it is ENOENT for xfs... argh.  I suppose the
>> quotactl manpage could use an update as well, then.
> 
> Yeah, so VFS quotas use ESRCH when quota for particular fs is not enabled
> (while ENOENT means device you passed in doesn't exist). So probably a
> solution that keeps XFS and VFS interfaces most selfconsistent is to return
> ENOENT from Q_XGETNEXTQUOTA and ESRCH from Q_GETNEXTQUOTA. I'll update your
> patches in this sense in the comments and changelogs. But XFS patches
> (which I don't carry) need updating the actual code...

*nod* thanks.  I'll just resend the XFS patches to the XFS list.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
