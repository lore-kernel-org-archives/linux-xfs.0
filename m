Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 11:26:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OIQiaG020723
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 11:26:46 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14CC9D1A65B0
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 11:26:00 -0700 (PDT)
Received: from agami.com ([192.168.168.147])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k9OIPx2J004609
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 11:25:59 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k9OIPr2K012319
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 11:25:53 -0700
Message-ID: <453E5A0F.4070902@agami.com>
Date: Tue, 24 Oct 2006 11:23:11 -0700
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: [REVIEW 3 of 4] Fix recalim handling in xfs_iget_core
References: <20061024072054.GT11034@melbourne.sgi.com>
In-Reply-To: <20061024072054.GT11034@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, t-nagano@ah.jp.nec.com, xfs-dev@sgi.com

Hi David,
               I can't really see why we need this test:
                if (xfs_iflags_test(ip, XFS_IRECLAIMABLE))
                I think, An inode with no VP can be possibly in only 3 
states (NEW, RECLAIM or RECLAIMABLE). This check is being made inside 
(inode_vp == NULL)  check. If I am correct, may be we can omit an extra 
instruction here.
              It appears that you can see inode with XFS_ISTALE can 
potentially reach. I am not sure how it should reach that path. 
Following code just after this assumes that it must be in reclaimable path:
        
                                XFS_MOUNT_ILOCK(mp);
                                list_del_init(&ip->i_reclaim);
                                XFS_MOUNT_IUNLOCK(mp);
  
Regards,
Shailendra

David Chinner wrote:
