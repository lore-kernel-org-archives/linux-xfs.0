Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8TFiZUT213746 for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 10:44:36 -0500
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8720A1B3078A
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 08:45:57 -0700 (PDT)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.145])
	by cuda.sgi.com with ESMTP id n2L3HpRVsmtEuRG4 for
	<xfs@oss.sgi.com>; Tue, 29 Sep 2009 08:45:57 -0700 (PDT)
Received: by qw-out-1920.google.com with SMTP id 5so1674880qwc.32
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 08:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090929130022.GD11375@infradead.org>
References: <46b8a8850909271220w372d60c3s18a543ed00825082@mail.gmail.com>
	<20090928172137.GA21868@infradead.org>
	<46b8a8850909281036j1bdbf61h18b4134912735d92@mail.gmail.com>
	<20090929130022.GD11375@infradead.org>
Date: Tue, 29 Sep 2009 08:45:56 -0700
Message-ID: <46b8a8850909290845o22589155ud1ab403b761e734c@mail.gmail.com>
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

On Tue, Sep 29, 2009 at 6:00 AM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> On Mon, Sep 28, 2009 at 10:36:13AM -0700, Richard Sharpe wrote:
>> Well, yes there is, but that is the problem I encountered. It is level
>> as passed in when starting at the top of the tree, which is obtained
>> from the levels value in the AGF, and is decremented by one on each
>> recursion:
>>
>> =A0 =A0 =A0 =A0 if (!(*func)(iocur_top->data, agno, agbno, level - 1, bt=
ype, arg))
>>
>> However, what should really be looked at is the value bb_level in the
>> header in each free-space Btree node.
>
> I think bother are equally valid. =A0The one passed in fro mthe top should
> always be right while the ondisk one might be corrupted.

Well, yes, but then anything could be corrupted on disk, including the
superblock and the pointers in interior nodes in the free space Btree.

>> After I made that change to my changes, I started being able to
>> properly count all leaf nodes and free extents, and the numbers came
>> out where I expected them to be (instead of not seeing many leaf nodes
>> and vastly undercounting free extents).
>
> Still not quite understanding your problem here. =A0Do you have a tool
> of your own that doesn't start from the btree root but only walks
> subtrees? =A0In that case you need to look at the on-disk level unless
> you can find out easily what level you start at. =A0But I don't think we
> need this for the existing tools that always walk from the root.

No, I was walking down from the root of the tree.

However, now I understand what is going on.

Assume a free space tree with levels =3D 3 (from the AGF). However, not
all leaf nodes will be at depth 3 in the tree, some will be at depth 2
in the tree.

However, in scanfunc_freesp we see:

        if (level =3D=3D 0)
                return 1;

        numrecs =3D be16_to_cpu(block->bb_numrecs);
        if (numrecs > mp->m_alloc_mxr[1]) {
                if (show_warnings)
                        print_warning("invalid numrecs (%u) in %s block %u/=
%u",
                                numrecs, typtab[btype].name, agno, agbno);
                return 1;
        }

If we hit level =3D=3D 0 then we exit, however, for a leaf node that is at
depth 2 (level 1, but bb_level =3D=3D 0) we will see numrecs >
mp->m_alloc_mxr[1] and will also skip such records (ie, will not
recurse into them).

However, if the user does "metadump -w" they will see warnings that
are bogus and suggests that the author was not really aware of the
real structure of the tree.

I do think it is a minor issue since it will not lead to dropping any
records as I first feared.

Since I wanted to count the number of free extents in the free-space
trees I needed to actually see all leaf nodes, and thus it became a
problem for me.

-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
