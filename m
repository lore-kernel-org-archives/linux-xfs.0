Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FCB17F92
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 08:44:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 086058F804B
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 06:44:29 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id AuLBiSwsGb1PEdV4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 06:44:28 -0800 (PST)
Message-ID: <52A728A7.8020905@oracle.com>
Date: Tue, 10 Dec 2013 18:43:51 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: nfs vs xfstests 193
References: <20131106115648.GA24804@infradead.org> <52A1CF22.106@oracle.com>
	<20131206180858.GA2803@infradead.org>
	<20131206204404.GA12613@fieldses.org>
	<20131206204747.GB12613@fieldses.org>
In-Reply-To: <20131206204747.GB12613@fieldses.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, Vasily Isaenko <vasily.isaenko@oracle.com>, linux-nfs@vger.kernel.org, "Sachin S. Prabhu" <sprabhu@redhat.com>, xfs@oss.sgi.com



On 12/07/2013 12:47 AM, J. Bruce Fields wrote:
> On Fri, Dec 06, 2013 at 03:44:04PM -0500, bfields wrote:
>> On Fri, Dec 06, 2013 at 10:08:58AM -0800, Christoph Hellwig wrote:
>>> On Fri, Dec 06, 2013 at 05:20:34PM +0400, Stanislav Kholmanskikh wrote:
>>>> Just to make the behaviour more consistent between NFS and other
>>>> "local" file systems as It was done by
>>>> commit https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=0953e620de0538cbd081f1b45126f6098112a598
>>>
>>> Seems like we got others in line with XFS behavior.
>>
>> But, not having tested the behavior, it looks like fs/open.c has a
>> simlar !S_ISDIR() check.  Where's that behavior implemented?
>>
>>> I'd prefer to have NFS follow this as well.
>>
>> Huh.  Sachin, do you remember if there was any other motivation behind
>> that patch?
>
> Never mind, I see, the complaint is about the case where the id's don't
> change, not about the directory case.  So Sachin's
> 0953e620de0538cbd081f1b45126f6098112a598 doesn't actually have anything
> to do with this.
>
> I'm fine with removing the id comparisons and changing the nfsd behavior
> to match local filesystems.

Great.

I will try to produce a patch for this.

>
> --b.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
