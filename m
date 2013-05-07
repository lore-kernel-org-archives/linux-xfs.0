Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3909429E03
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 14:31:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8837AC009
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 12:31:51 -0700 (PDT)
Date: Tue, 7 May 2013 15:31:46 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
Message-ID: <20130507193146.GA7539@redhat.com>
References: <20130507133707.GA18301@redhat.com> <51895025.2010709@sgi.com>
	<20130507190731.GA15528@redhat.com> <518954DE.4070803@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518954DE.4070803@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Tue, May 07, 2013 at 02:24:14PM -0500, Mark Tinguely wrote:
 > On 05/07/13 14:07, Dave Jones wrote:
 > > On Tue, May 07, 2013 at 02:04:05PM -0500, Mark Tinguely wrote:
 > >   >  On 05/07/13 08:37, Dave Jones wrote:
 > >   >  >     172.233570] Bytes b4 ffff8800aaac4e28: 07 a2 fd ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
 > >   >  >  [  172.233573] Object ffff8800aaac4e38: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 > >   >  >  [  172.233575] Object ffff8800aaac4e48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 > >   >  >  [  172.233577] Object ffff8800aaac4e58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 > >   >  >  [  172.233579] Object ffff8800aaac4e68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 > >   >  >  [  172.233581] Object ffff8800aaac4e78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 > >   >  >  [  172.233583] Object ffff8800aaac4e88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 > >   >  >  [  172.233586] Object ffff8800aaac4e98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 > >   >  >  [  172.233588] Object ffff8800aaac4ea8: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  jkkkkkkkkkkkkkkk
 > >   >                                             ^^
 > >   >
 > >   >  xfs_efi_log_item.efi_refcount being decremented on the xfs_efi_release()
 > >   >  CAI Qian had the same thing in his May 6 "3.9.0: XFS rootfs corruption"
 > >   >  email.
 > >   >
 > >   >  I have not reproduced it yet.
 > >
 > > I've hit it on two different machines today. The good news is that the
 > > corruption never makes it onto disk. xfs_repair doesn't pick up anything.
 > >
 > > 	Dave
 > >
 > There was a new patch in the efi/efd code that must be misbehaving.
 > You are correct, this is not an on-disk value.
 > 
 > I now have poisoning on and I can see this doing a compile like you 
 > suggested. I will ASSERT to see who is doing the decrement after free.

I can hit this almost instantly with fsx. I'll do a bisect, though
it sounds like you already have a suspect.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
