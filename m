Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 576E57F57
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 17:33:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 438638F8052
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 15:33:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id oBNv9QD5nDH3PmIk for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 15:33:27 -0700 (PDT)
Message-ID: <540F803A.9060901@sandeen.net>
Date: Tue, 09 Sep 2014 17:33:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfs_repair: clear bad flgs in process_dinode_int
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>	<1410108065-18156-2-git-send-email-sandeen@redhat.com>
	<20140909222856.GA27349@infradead.org>
In-Reply-To: <20140909222856.GA27349@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 9/9/14 5:28 PM, Christoph Hellwig wrote:
> On Sun, Sep 07, 2014 at 11:41:01AM -0500, Eric Sandeen wrote:
>> process_dinode_int() reports bad flags if
>> dino->di_flags & ~XFS_DIFLAG_ANY - i.e. if
>> any flags are set outside the known set.  But
>> then instead of clearing them, it does
>> flags &= ~XFS_DIFLAG_ANY which keeps *only*
>> the bad flags.  This leads to persistent,
>> unrepairable errors of the form:
>
> You know you can use up to 75 characters per line for your commit messages,
> don't you? :)

hah, it's not automated at all, I guess my visual perception
of the window is shrinking.  Dave, feel free to fix on commit if
inclined :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
