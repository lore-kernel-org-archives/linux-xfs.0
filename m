Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3KIjcPW079505 for <xfs@oss.sgi.com>; Mon, 20 Apr 2009 13:45:38 -0500
Received: from mail.isg.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C38641CD3E72
	for <xfs@oss.sgi.com>; Mon, 20 Apr 2009 11:45:32 -0700 (PDT)
Received: from mail.isg.de (rzfoobar.is-asp.com [217.11.194.155]) by
	cuda.sgi.com with ESMTP id HJ34ipwjh1XJrhPc for
	<xfs@oss.sgi.com>; Mon, 20 Apr 2009 11:45:32 -0700 (PDT)
Message-ID: <49ECC2CA.20108@isg.de>
Date: Mon, 20 Apr 2009 20:45:30 +0200
From: Peter Niemayer <niemayer@isg.de>
MIME-Version: 1.0
Subject: Re: XFS support for TRIM / blkdev_issue_discard?
References: <20090331053013.7642414167108@attica.americas.sgi.com>	<49E4A131.5040309@isg.de>	<BB5058FD-E69F-4254-9548-82CD634C7FD6@sgi.com>
	<20090419081927.GE16929@discord.disaster>
	<49EB487C.1020205@sandeen.net>
In-Reply-To: <49EB487C.1020205@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Dave Chinner wrote:
>> I did some initial work on tracking extents being freed, but then
>> the TRIM request morphed into a "tell the largest free space around
>> the area just freed" and that is much harder to do than simply to
>> issue a "we just freed this bit" command.
> 
> FWIW, ext[34] is still doing it block by block.  At least for SSDs, I
> think that's fine, isn't it? 

Well, theoretically, if there was a SSD that on one hand was sophisticated
enough to provide TRIM support, but would otherwise not use an intelligent
controller or cache memory and thus could pre-erase blocks only if the
TRIM was applied to a whole erase block at once, then even a SSD could
benefit from "telling the largest free space around the area just freed".

In practice, I don't think there will ever be a SSD like that on the market,
the primitive ones do not support TRIM, the sophisticated ones will
keep book of unused sectors internally and will notice when a whole erase-block
became empty and thus ready for proactive erasing.

And I did not find any requirement or hint to "tell the largest free space around
the area just freed" in
http://www.t13.org/Documents/UploadedDocuments/docs2008/e07154r6-Data_Set_Management_Proposal_for_ATA-ACS2.doc

Regards,

Peter Niemayer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
