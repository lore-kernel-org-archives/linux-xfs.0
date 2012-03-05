Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25GGF7J226375 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 10:16:16 -0600
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	vOPE1aLlv5KIKqCN (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 Mar 2012 08:16:14 -0800 (PST)
Received: by ggni4 with SMTP id i4so2613803ggn.26
	for <xfs@oss.sgi.com>; Mon, 05 Mar 2012 08:16:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120302074558.GB4117@infradead.org>
References: <1330636285-11200-1-git-send-email-kdasu.kdev@gmail.com>
	<de74feb44ebd887269fe85d9a5879765afccf4c2.1330635228.git.kdasu.kdev@gmail.com>
	<20120302074558.GB4117@infradead.org>
Date: Mon, 5 Mar 2012 11:16:13 -0500
Message-ID: <CAC=U0a14QA1+UpkVJZtbJf1F6kVdKbYyWFKRD8Ex_j61L3s7oA@mail.gmail.com>
Subject: Re: [PATCH 1/2] xfsprogs: replace deprecated ustat call with statfs
	in libxfs/linux.c
From: Kamal Dasu <kdasu.kdev@gmail.com>
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
To: xfs@oss.sgi.com
Cc: Kevin Cernekee <cernekee@gmail.com>

Christoph,

> More seriously - ustat provides the benefit to check if the block device
> is mounted anywhere, which we make use of here.  A statfs of the block
> device path doesn't provide that functionality at all.
>

Now I understand your concern. However if we would want to replace the
deprecated ustat call, then what other way would be acceptable to
achieve the same. Would parsing the /proc/mounts for the block device
name suffice ?.

Thanks
Kamal

On Fri, Mar 2, 2012 at 2:45 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Mar 01, 2012 at 04:11:24PM -0500, Kamal Dasu wrote:
>> >From the ustat man page
>>
>> NOTES
>> =A0 =A0 =A0 =A0ustat() is deprecated and has only =A0been =A0provided =
=A0for =A0compatibility.
>> =A0 =A0 =A0 =A0All new programs should use statfs(2) instead.
>
> xfsprogs isn't new :)
>
> More seriously - ustat provides the benefit to check if the block device
> is mounted anywhere, which we make use of here. =A0A statfs of the block
> device path doesn't provide that functionality at all.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
