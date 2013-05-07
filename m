Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C99BA29DFA
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 14:04:03 -0500 (CDT)
Message-ID: <51895025.2010709@sgi.com>
Date: Tue, 07 May 2013 14:04:05 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
References: <20130507133707.GA18301@redhat.com>
In-Reply-To: <20130507133707.GA18301@redhat.com>
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
To: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, CAI Qian <caiqian@redhat.com>

On 05/07/13 08:37, Dave Jones wrote:
>    172.233570] Bytes b4 ffff8800aaac4e28: 07 a2 fd ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
> [  172.233573] Object ffff8800aaac4e38: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233575] Object ffff8800aaac4e48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233577] Object ffff8800aaac4e58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233579] Object ffff8800aaac4e68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233581] Object ffff8800aaac4e78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233583] Object ffff8800aaac4e88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233586] Object ffff8800aaac4e98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233588] Object ffff8800aaac4ea8: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  jkkkkkkkkkkkkkkk
                                           ^^

xfs_efi_log_item.efi_refcount being decremented on the xfs_efi_release()
CAI Qian had the same thing in his May 6 "3.9.0: XFS rootfs corruption" 
email.

I have not reproduced it yet.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
