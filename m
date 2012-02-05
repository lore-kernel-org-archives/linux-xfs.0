Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15JOT1Z071311 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 13:24:29 -0600
Received: from idcmail-mo1so.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by
	cuda.sgi.com with ESMTP id VZAiz8eAEUp2pXEI for
	<xfs@oss.sgi.com>; Sun, 05 Feb 2012 11:24:27 -0800 (PST)
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Mime-Version: 1.0 (Apple Message framework v1084)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <4F2EBB09.6080905@redhat.com>
Date: Sun, 5 Feb 2012 12:24:26 -0700
Message-Id: <D9A6076F-154F-41A6-BC18-EC1AF2E73551@dilger.ca>
References: <4F2D8F30.3090802@redhat.com>
	<201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
	<4F2EB017.5090006@redhat.com>
	<9C5B5C07-B0E4-4D13-BCFE-7F35162DF5E8@dilger.ca>
	<4F2EBB09.6080905@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Ron Yorston <rmy@tigress.co.uk>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 2012-02-05, at 10:23 AM, Eric Sandeen wrote:
> On 2/5/12 10:55 AM, Andreas Dilger wrote:
>> On 2012-02-05, at 9:36, Eric Sandeen <sandeen@redhat.com> wrote:
>>> On 2/5/12 3:33 AM, Ron Yorston wrote:
>>>> Eric Sandeen wrote:
>>>>> Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
>>>>> "re-sparsify" a file by punching out ranges of 0s might be in order.
>>>>> 
>>>>> I'll see if util-linux wants it after it gets beat into shape.
>>>>> (or did a tool like this already exist and I missed it?)
>>> 
>>> Matthias' suggestion of adding SEEK_HOLE/SEEK_DATA makes very good sense too.
>> 
>> I thought about this, but if SEEK_HOLE/SEEK_DATA (or FIEMAP) worked,
>> then the file would already be sparse, so I don't think that will
>> help in this case...
> 
> But only if other tools originally used them, and there will probably be plenty
> of cases where they don't, or legacy files, or ....

I was thinking that the suggestion was to use SEEK_HOLE/SEEK_DATA to find
the holes in the file...  Of course, it makes a lot of sense if you use
them to skip the existing holes, and only look for strings of zeros in the
data parts...

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
