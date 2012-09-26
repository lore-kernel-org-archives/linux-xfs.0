Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8Q6CkmQ165201 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 01:12:46 -0500
Received: from mail-vb0-f53.google.com (mail-vb0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id mcf9JamOpqzVHErD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Sep 2012 23:14:03 -0700 (PDT)
Received: by vbbfc21 with SMTP id fc21so256386vbb.26
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 23:14:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120921071644.GA20650@Archie>
References: <cover.1347396641.git.rprabhu@wnohang.net>
	<93d9b37ce9ad720e14e2f9311e623a8e3e3139f5.1347396641.git.rprabhu@wnohang.net>
	<20120911232144.GH11511@dastard> <20120921071644.GA20650@Archie>
Date: Wed, 26 Sep 2012 11:44:02 +0530
Message-ID: <CAEtq3tN9h=Z7Pw9EDKdqOR-jCFGQj4ewjUu7--VMUwbjSc2S6A@mail.gmail.com>
Subject: Re: Re: [PATCH 3/3] XFS: Print error when unable to allocate inodes
	or out of free inodes.
From: Raghavendra Prabhu <raghu.prabhu13@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

Hi,

On Fri, Sep 21, 2012 at 12:46 PM, Raghavendra D Prabhu
<raghu.prabhu13@gmail.com> wrote:
> Hi,
>
>
>>
>>> +                               goto out_spc;
>>> +                       }
>>> +                       return 0;
>>>                 }
>>>         }
>>>
>>> +out_spc:
>>> +       *inop = NULLFSINO;
>>> +       return ENOSPC;
>>>  out_alloc:
>>>         *IO_agbp = NULL;
>>>         return xfs_dialloc_ag(tp, agbp, parent, inop);
>>
>>
>> Default behaviour on a loop break is to allocate inodes, not return
>> ENOSPC.
>>
>> BTW, there's no need to cc LKML for XFS specific patches. LKML is
>> noisy enough as it is without unnecessary cross-posts....
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>

Ignore the previous. Resending the patch with fixes mentioned.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
