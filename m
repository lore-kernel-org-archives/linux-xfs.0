Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p61EUaoJ070191 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 09:30:36 -0500
Received: from e35.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9D6616759A6
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 07:30:34 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id SuzeDQ580EmXKtBd for
	<xfs@oss.sgi.com>; Fri, 01 Jul 2011 07:30:34 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p61EC5PE007828
	for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 08:12:05 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p61EUKvB136742 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 08:30:23 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p618UJ4c017207
	for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 02:30:19 -0600
Message-ID: <4E0DD9FB.8090307@linux.vnet.ibm.com>
Date: Fri, 01 Jul 2011 07:30:19 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2v v7] XFS TESTS: ENOSPC Punch Hole Test
References: <1309272301-5742-1-git-send-email-achender@linux.vnet.ibm.com>
In-Reply-To: <1309272301-5742-1-git-send-email-achender@linux.vnet.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 06/28/2011 07:44 AM, Allison Henderson wrote:
> Hi All,
>
> This is another set I sent out a while ago, but I didnt see it show up on the lists,
> so I am resending this one too. The work in this patch is a continuation from a
> previous patch set that has been partially accepted, so I thought I
> should retain the v6.
>
> This patch set adds the ENOSPC test that was used for ext4 punch hole testing.
> This test will verify that a hole can be punched even when the disk is full.
> Reserved blocks should be used to complete the operation when there is not blocks
> to further fragment the file.
>
> Because punching a hole does not always require extra blocks, there needs to
> be serveal iterations of punching holes, and then filling the file system to 100%
> usage before it is forced to grow the tree in order to handle the fragmentation.
> The growing of the tree is what would cause ENOSPC if not for the use of reserved blocks.
>
> I could use some opinions on this patch set becuase I am not sure if other filesystems
> handle their punch holes in the same way.  Although xfs appears to pass the test,
> should this test be an ext4 only test? Thx!
>

Hi All,

I just wanted to poke this thread before too much time goes by.  This 
patch was initially part of an earlier set that's already been picked 
up, and it seemed like people were generally interested in it, so I 
resubmitted it as it's own patch.  Is there still an interest in this 
patch set?

I have another set that now also needs to add a new test 255 (the fix 
252 failure patch set).  I am thinking that if people still want this 
test, I could put this patch in with the other set so that they stack 
properly.  Thx!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
