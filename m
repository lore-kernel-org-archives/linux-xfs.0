Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E51A87CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 10:43:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F3888F8033
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 08:43:47 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id XeOiTd9qXeNGKJyz (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 08:43:45 -0700 (PDT)
Subject: Re: [PATCH 28/45] target: use bio op accessors
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-29-git-send-email-mchristi@redhat.com>
	<57551C57.5090507@suse.de> <57559973.1020105@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <57559A20.10506@suse.de>
Date: Mon, 6 Jun 2016 17:43:28 +0200
MIME-Version: 1.0
In-Reply-To: <57559973.1020105@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mike Christie <mchristi@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On 06/06/2016 05:40 PM, Mike Christie wrote:
> On 06/06/2016 01:46 AM, Hannes Reinecke wrote:
>> On 06/05/2016 09:32 PM, mchristi@redhat.com wrote:
>>> From: Mike Christie <mchristi@redhat.com>
>>>
>>> Separate the op from the rq_flag_bits and have the target layer
>>> set/get the bio using bio_set_op_attrs/bio_op.
>>>
>>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>>> ---
>>>   drivers/target/target_core_iblock.c | 29 ++++++++++++++---------------
>>>   drivers/target/target_core_pscsi.c  |  2 +-
>>>   2 files changed, 15 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/targe=
t_core_iblock.c
>>> index c25109c..22af12f 100644
>>> --- a/drivers/target/target_core_iblock.c
>>> +++ b/drivers/target/target_core_iblock.c
>> [ .. ]
>>> @@ -689,18 +690,15 @@ iblock_execute_rw(struct se_cmd *cmd, struct scat=
terlist *sgl, u32 sgl_nents,
>>>   		 * Force writethrough using WRITE_FUA if a volatile write cache
>>>   		 * is not enabled, or if initiator set the Force Unit Access bit.
>>>   		 */
>>> +		op =3D REQ_OP_WRITE;
>>>   		if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
>>>   			if (cmd->se_cmd_flags & SCF_FUA)
>>> -				rw =3D WRITE_FUA;
>>> +				op_flags =3D WRITE_FUA;
>>>   			else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
>>> -				rw =3D WRITE_FUA;
>>> -			else
>>> -				rw =3D WRITE;
>>> -		} else {
>>> -			rw =3D WRITE;
>>> +				op_flags =3D WRITE_FUA;
>>>   		}
>> Wrong intendation.
>
> It should be ok. That line is for the QUEUE_FLAG_WC test. We end up with:
>
> op =3D REQ_OP_WRITE;
> if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
> 	if (cmd->se_cmd_flags & SCF_FUA)
> 		op_flags =3D WRITE_FUA;
> 	else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> 		op_flags =3D WRITE_FUA;
> }
>
>
>
>
Indeed, you are correct.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
