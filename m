Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8SHYrm6137908 for <xfs@oss.sgi.com>; Mon, 28 Sep 2009 12:34:53 -0500
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D548D4855A0
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2009 10:36:14 -0700 (PDT)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.221.181]) by cuda.sgi.com with ESMTP id
	VC7FXQjet29j2WxG for <xfs@oss.sgi.com>;
	Mon, 28 Sep 2009 10:36:14 -0700 (PDT)
Received: by qyk11 with SMTP id 11so3548366qyk.20
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2009 10:36:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090928172137.GA21868@infradead.org>
References: <46b8a8850909271220w372d60c3s18a543ed00825082@mail.gmail.com>
	<20090928172137.GA21868@infradead.org>
Date: Mon, 28 Sep 2009 10:36:13 -0700
Message-ID: <46b8a8850909281036j1bdbf61h18b4134912735d92@mail.gmail.com>
Subject: Re: Possible small bug in xfsprogs-dev/db/metadump.c
From: Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 28, 2009 at 10:21 AM, Christoph Hellwig <hch@infradead.org> wro=
te:
> [Cc'ed to the list, where people including the most active person on the
> =A0userspace side hang out]
>
> On Sun, Sep 27, 2009 at 12:20:33PM -0700, Richard Sharpe wrote:
>> Hi folks,
>>
>> There seems to be a small bug in
>> xfsprogs-dev/db/metadump.c:scanfunc_freesp (although I think the same
>> problem exists in other functions).
>>
>> It has a check to see if the number of records is invalid:
>>
>> =A0 =A0 =A0 =A0 numrecs =3D be16_to_cpu(block->bb_numrecs);
>> =A0 =A0 =A0 =A0 if (numrecs > mp->m_alloc_mxr[1]) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (show_warnings)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print_warning("invalid n=
umrecs (%u) in %s block %u/%u",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 numrecs,=
 typtab[btype].name, agno, agbno);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> =A0 =A0 =A0 =A0 }
>>
>> However, it seems to me that you should pay attention to bb_level in
>> the node when using that test, because leaf nodes can appear at
>> multiple levels in the tree.
>
> Before that code there is a
>
> =A0 =A0 =A0 =A0if (level =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
>
> which should take care of the leaf nodes by exiting early.

Well, yes there is, but that is the problem I encountered. It is level
as passed in when starting at the top of the tree, which is obtained
from the levels value in the AGF, and is decremented by one on each
recursion:

        if (!(*func)(iocur_top->data, agno, agbno, level - 1, btype, arg))

However, what should really be looked at is the value bb_level in the
header in each free-space Btree node.

After I made that change to my changes, I started being able to
properly count all leaf nodes and free extents, and the numbers came
out where I expected them to be (instead of not seeing many leaf nodes
and vastly undercounting free extents).





-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
