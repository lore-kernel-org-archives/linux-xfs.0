Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 444C07CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 16:05:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 343A48F8040
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 14:05:36 -0800 (PST)
Received: from mail-yw0-f170.google.com (mail-yw0-f170.google.com
	[209.85.161.170]) by cuda.sgi.com with ESMTP id
	aX1d6S6gEX8Ov3zB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 14:05:34 -0800 (PST)
Received: by mail-yw0-f170.google.com with SMTP id q190so113406520ywd.3
	for <xfs@oss.sgi.com>; Mon, 08 Feb 2016 14:05:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <x49vb5yvrzv.fsf@segfault.boston.devel.redhat.com>
References: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
	<1454829553-29499-3-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4jT=yAb2_yLfMGqV1SdbQwoWQj7joroeJGAJAcjsMY_oQ@mail.gmail.com>
	<20160207215047.GJ31407@dastard>
	<CAPcyv4jNmdm-ATTBaLLLzBT+RXJ0YrxxXLYZ=T7xUgEJ8PaSKw@mail.gmail.com>
	<20160208201808.GK27429@dastard>
	<CAPcyv4iHi17pv_VC=WgEP4_GgN9OvSr8xbw1bvbEFMiQ83GbWw@mail.gmail.com>
	<x49vb5yvrzv.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 8 Feb 2016 14:05:34 -0800
Message-ID: <CAPcyv4iHaFNBRBb4EYPfHX+pB5srJbqrOX7FnDXyDPy92Cnpww@mail.gmail.com>
Subject: Re: [PATCH 2/2] dax: move writeback calls into the filesystems
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Feb 8, 2016 at 12:58 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> I agree the mount option needs to die, and I fully grok the reasoning.
>>   What I'm concerned with is that a system using fully-DAX-aware
>> applications is forced to incur the overhead of maintaining *sync
>> semantics, periodic sync(2) in particular,  even if it is not relying
>> on those semantics.
>>
>> However, like I said in my other mail, we can solve that with
>> alternate interfaces to persistent memory if that becomes an issue and
>> not require that "disable *sync" capability to come through DAX.
>
> What do you envision these alternate interfaces looking like?

Well, plan-A was making DAX be explicit opt-in for applications, I
haven't thought too much about plan-B.  I expect it to be driven by
real performance numbers and application use cases once the *sync
compat work completes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
