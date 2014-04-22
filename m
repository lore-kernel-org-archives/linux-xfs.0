Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 565977F56
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 10:54:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 120D28F8065
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 08:54:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ml2hGzL7cweEncca for
	<xfs@oss.sgi.com>; Tue, 22 Apr 2014 08:54:34 -0700 (PDT)
Message-ID: <535690A3.3080609@redhat.com>
Date: Tue, 22 Apr 2014 10:54:11 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix Q_XQUOTARM ioctl
References: <535580A1.20806@redhat.com> <20140422064316.GA30375@infradead.org>
In-Reply-To: <20140422064316.GA30375@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/22/14, 1:43 AM, Christoph Hellwig wrote:
> On Mon, Apr 21, 2014 at 03:33:37PM -0500, Eric Sandeen wrote:
>> The Q_XQUOTARM quotactl was not working properly, because
>> we weren't passing around proper flags.  The xfs_fs_set_xstate()
>> ioctl handler used the same flags for Q_XQUOTAON/OFF as
>> well as for Q_XQUOTARM, but Q_XQUOTAON/OFF look for
>> XFS_UQUOTA_ACCT, XFS_UQUOTA_ENFD, XFS_GQUOTA_ACCT etc,
>> i.e. quota type + state, while Q_XQUOTARM looks only for
>> the type of quota, i.e. XFS_DQ_USER, XFS_DQ_GROUP etc.
>>
>> Unfortunately these flag spaces overlap a bit, so we
>> got semi-random results for Q_XQUOTARM; i.e. the value
>> for XFS_DQ_USER == XFS_UQUOTA_ACCT, etc.  yeargh.
>>
>> Split out the flag conversion from userspace to kernelspace,
>> depending on the quotactl that is being executed; add 2 new
>> helpers to do this, so that we send the right flags to the
>> lower-level functions.
>>
>> This has been broken more or less forever, AFAICT.
> 
> So if this isn't very urgent I'd rather replace ->set_xstate with one
> operation per ioctl, so that we don't multiple different kinds of flags
> over the same operation.
> 

eh, that's probably better, I'll take a look.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
