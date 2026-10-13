Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34813B3BFA;
	Tue, 13 Oct 2026 08:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791881213; cv=none; b=FZLTMaf8ENUTMgFYgYJGp33bnM/E7wMmt4Qi3tceyFnLidlq9MI62WdIQLpDDpKpTXx0joZTB91//KdvvIjiMtNfCs0ai4iLNsmmfs/0DB6bg3M2SAGnX8D+/laaDC4E8vnOlJYhmcAYFjPk7ODqL196DhJ33AIrkM5CsHwuUrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791881213; c=relaxed/simple;
	bh=VrPJMJe0p9+6NmVwArnE42b3BamDqINLuKq4y3V1Qqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBv3h7X08ng3VqCTcel2f+9DzBV84+wL9Z2sdKbCjQRSsS+wlYZaa+Z1PeOAzKU8jZkQzRjbqGSNAqLJCNTJ+9ZPQF/IvA6dnJGSvCoSY045sTbTKlyFAF51HzxN0tv2v7Q3Bd49nRYQ2osw0e2/605+CdNDXPiJQSVS9dTOrfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egXBix+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egXBix+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D051F000FF;
	Tue, 13 Oct 2026 08:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791881211;
	bh=YTUg/x+O3iIclzczfs85T9AbyfqNZtpk7ieuCJzf8PY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=egXBix+UwTx8gGA08cvB95m4CUxBjds7Ep8k6GQ2H2FqO4pqEEjAnmMPB3Vtw+mnC
	 fuDs3tDrXapSwCztSGv4bqulJuedniQ0aDIH6T+DN7pdKXt0HtPTJhBDBm/8Nh3UI7
	 XrzCE6q2H2HWIwXmrDvoqXamV8J55VBgM5vP1uo8=
Date: Tue, 13 Oct 2026 10:46:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
	linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 v2 0/5] Backport of XFS umount hang fixes
Message-ID: <2026101349-punctured-overload-7f09@gregkh>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
 <cover.1791877866.git.siddh.raman.pant@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>

On Tue, Oct 13, 2026 at 01:43:44PM +0530, Siddh Raman Pant wrote:
> Backport of this series:
> https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/
> 
> I have added information in commit message upon conflict resolutions.
> 
> v2: Address Sasha's comments to v1 in the below mail:
> https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

I appreciate the backports, but wow, this is going to be a mess to sift
through because you mixed all the different branches together.  Here's
how it looks in my email client:

   3 N   Oct 13 Siddh Raman Pan (1.6K) ┬─>[PATCH 6.1 v2 0/5] Backport of XFS umount hang fixes                                                                                                             
   4 N   Oct 13 Siddh Raman Pan (2.2K) │ ├─>[PATCH 5.10 v2 07/19] xfs: don't nest icloglock inside ic_callback_lock                                                                                        
   5 N   Oct 13 Siddh Raman Pan (4.0K) │ ├─>[PATCH 5.10 v2 13/19] xfs: fix intermittent hang during quotacheck                                                                                             
   6 N   Oct 13 Siddh Raman Pan ( 25K) │ ├─>[PATCH 5.10 v2 11/19] xfs: remove xfs_buf_t typedef                                                                                                            
   7 N   Oct 13 Siddh Raman Pan (5.6K) │ ├─>[PATCH 5.10 v2 12/19] xfs: fix super block buf log item UAF during force shutdown                                                                              
   8 N   Oct 13 Siddh Raman Pan (2.2K) │ ├─>[PATCH 5.10 v2 04/19] xfs: improve the code that checks recovered rmap intent items                                                                            
   9 N   Oct 13 Siddh Raman Pan (9.3K) │ ├─>[PATCH 5.10 v2 16/19] xfs: catch stale AGF/AGF metadata                                                                                                        
  10 N   Oct 13 Siddh Raman Pan (3.2K) │ ├─>[PATCH 5.10 v2 18/19] xfs: factor out stale buffer item completion                                                                                             
  11 N   Oct 13 Siddh Raman Pan (7.9K) │ ├─>[PATCH 5.10 v2 09/19] xfs: log items should have a xlog pointer, not a mount                                                                                   
  12 N   Oct 13 Siddh Raman Pan ( 12K) │ ├─>[PATCH 5.15 v2 9/9] xfs: fix unmount hang with unflushable inodes stuck in the AIL                                                                             
  13 N   Oct 13 Siddh Raman Pan (5.7K) │ ├─>[PATCH 5.15 v2 7/9] xfs: rearrange code in xfs_buf_item.c                                                                                                      
  14 N   Oct 13 Siddh Raman Pan (2.0K) │ ├─>[PATCH 5.10 v2 06/19] xfs: improve the code that checks recovered refcount intent items                                                                        
  15 N   Oct 13 Siddh Raman Pan (3.3K) │ ├─>[PATCH 5.10 v2 05/19] xfs: hoist recovered refcount intent checks out of xfs_cui_item_recover                                                                  
  16 N   Oct 13 Siddh Raman Pan (3.9K) │ ├─>[PATCH 5.10 v2 01/19] xfs: hoist recovered bmap intent checks out of xfs_bui_item_recover                                                                      
  17 N   Oct 13 Siddh Raman Pan (9.1K) │ ├─>[PATCH 5.10 v2 10/19] xfs: aborting inodes on shutdown may need buffer lock                                                                                    
  18 N   Oct 13 Siddh Raman Pan (5.6K) │ ├─>[PATCH 6.1 v2 3/5] xfs: rearrange code in xfs_buf_item.c                                                                                                       
  19 N   Oct 13 Siddh Raman Pan ( 12K) │ ├─>[PATCH 5.10 v2 19/19] xfs: fix unmount hang with unflushable inodes stuck in the AIL                                                                           
  20 N   Oct 13 Siddh Raman Pan (3.2K) │ ├─>[PATCH 6.1 v2 4/5] xfs: factor out stale buffer item completion                                                                                                
  21 N   Oct 13 Siddh Raman Pan (5.7K) │ ├─>[PATCH 5.10 v2 17/19] xfs: rearrange code in xfs_buf_item.c                                                                                                    
  22 N   Oct 13 Siddh Raman Pan (5.6K) │ ├─>[PATCH 6.1 v2 1/5] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock                                                                                
  23 N   Oct 13 Siddh Raman Pan (5.8K) │ ├─>[PATCH 5.10 v2 15/19] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock                                                                             
  24 N   Oct 13 Siddh Raman Pan (7.3K) │ ├─>[PATCH 5.10 v2 14/19] xfs: buffer pins need to hold a buffer reference                                                                                         
  25 N   Oct 13 Siddh Raman Pan (6.5K) │ ├─>[PATCH 5.15 v2 1/9] xfs: log items should have a xlog pointer, not a mount                                                                                     
  26 N   Oct 13 Siddh Raman Pan (5.6K) │ ├─>[PATCH 5.15 v2 3/9] xfs: fix super block buf log item UAF during force shutdown                                                                                
  27 N   Oct 13 Siddh Raman Pan ( 12K) │ ├─>[PATCH 6.1 v2 5/5] xfs: fix unmount hang with unflushable inodes stuck in the AIL                                                                              
  28 N   Oct 13 Siddh Raman Pan (8.1K) │ ├─>[PATCH 5.10 v2 08/19] xfs: convert XLOG_FORCED_SHUTDOWN() to xlog_is_shutdown()                                                                                
  29 N   Oct 13 Siddh Raman Pan (3.5K) │ ├─>[PATCH 5.10 v2 03/19] xfs: hoist recovered rmap intent checks out of xfs_rui_item_recover                                                                      
  30 N   Oct 13 Siddh Raman Pan (2.3K) │ ├─>[PATCH 5.10 v2 02/19] xfs: improve the code that checks recovered bmap intent items                                                                            
  31 N   Oct 13 Siddh Raman Pan (3.2K) │ ├─>[PATCH 5.15 v2 8/9] xfs: factor out stale buffer item completion                                                                                               
  32 N   Oct 13 Siddh Raman Pan (8.8K) │ ├─>[PATCH 5.15 v2 6/9] xfs: catch stale AGF/AGF metadata                                                                                                          
  33 N   Oct 13 Siddh Raman Pan (5.6K) │ ├─>[PATCH 5.15 v2 5/9] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock                                                                               
  34 N   Oct 13 Siddh Raman Pan (7.3K) │ ├─>[PATCH 5.15 v2 4/9] xfs: buffer pins need to hold a buffer reference                                                                                           
  35 N   Oct 13 Siddh Raman Pan (9.1K) │ ├─>[PATCH 5.15 v2 2/9] xfs: aborting inodes on shutdown may need buffer lock                                                                                      
  36 N   Oct 13 Siddh Raman Pan (8.5K) │ └─>[PATCH 6.1 v2 2/5] xfs: catch stale AGF/AGF metadata                                                                                                           
  37 N   Oct 13 Siddh Raman Pan (1.6K) └─>[PATCH 6.12 v2 0/6] Backport of XFS umount hang fixes                                                                                                            
  38 N   Oct 13 Siddh Raman Pan ( 12K)   ├─>[PATCH 6.6 v2 5/5] xfs: fix unmount hang with unflushable inodes stuck in the AIL                                                                              
  39 N   Oct 13 Siddh Raman Pan (5.6K)   ├─>[PATCH 6.6 v2 3/5] xfs: rearrange code in xfs_buf_item.c                                                                                                       
  40 N   Oct 13 Siddh Raman Pan (8.6K)   ├─>[PATCH 6.6 v2 2/5] xfs: catch stale AGF/AGF metadata                                                                                                           
  41 N   Oct 13 Siddh Raman Pan (5.6K)   ├─>[PATCH 6.6 v2 1/5] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock                                                                                
  42 N   Oct 13 Siddh Raman Pan (3.2K)   ├─>[PATCH 6.12 v2 5/6] xfs: factor out stale buffer item completion                                                                                               
  43 N   Oct 13 Siddh Raman Pan ( 15K)   ├─>[PATCH 6.12 v2 3/6] xfs: avoid dquot buffer pin deadlock                                                                                                       
  44 N   Oct 13 Siddh Raman Pan (5.0K)   ├─>[PATCH 6.12 v2 4/6] xfs: rearrange code in xfs_buf_item.c                                                                                                      
  45 N   Oct 13 Siddh Raman Pan (3.2K)   ├─>[PATCH 6.6 v2 4/5] xfs: factor out stale buffer item completion                                                                                                
  46 N   Oct 13 Siddh Raman Pan (8.0K)   ├─>[PATCH 6.12 v2 2/6] xfs: catch stale AGF/AGF metadata                                                                                                          
  47 N   Oct 13 Siddh Raman Pan ( 12K)   ├─>[PATCH 6.12 v2 6/6] xfs: fix unmount hang with unflushable inodes stuck in the AIL                                                                             
  48 N   Oct 13 Siddh Raman Pan (5.6K)   └─>[PATCH 6.12 v2 1/6] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock                                 


What would you do if you got something like this?  :)

thanks,

greg k-h
