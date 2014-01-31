Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 986DE7CBE
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 04:45:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 379FFAC001
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 02:45:19 -0800 (PST)
Received: from gproxy3-pub.mail.unifiedlayer.com
	(gproxy3-pub.mail.unifiedlayer.com [69.89.30.42]) by
	cuda.sgi.com with SMTP id L15IhggNfAk0ix9p for
	<xfs@oss.sgi.com>; Fri, 31 Jan 2014 02:45:17 -0800 (PST)
Message-ID: <1391165083.4275.7.camel@ubuntu>
Subject: Re: Extended attributes limit in Linux
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Date: Fri, 31 Jan 2014 14:44:43 +0400
In-Reply-To: <52EB64DC.4020603@oracle.com>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>
	<52EB64DC.4020603@oracle.com>
Mime-Version: 1.0
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Sun_Blood <sblood@gmail.com>, xfs@oss.sgi.com

On Fri, 2014-01-31 at 16:54 +0800, Jeff Liu wrote:
> Hello,
> 
> On 01/31 2014 15:40 PM, Sun_Blood wrote:
> > Hello,
> > 
> > If I understands it correctly XFS don't have a limit to the size of
> > extended attributes(EA) but Linux impose a limit at 64k.
> > What I am trying to do is build a backup server that our Apple computers
> > will use together with rsync to backup files to. The problem I face is
> > that Apple HFS+ don't have a limit to EA so it has files with more then
> > 64k of EA in it.

Technical Note TN1150:
"In an HFS Plus B-tree, the node size is determined by a field
(nodeSize) in the header node. The node size must be a power from 512
through 32,768."

So, as minimum, xattrs unable to be a larger than node size.

But xattrs' size has limitation anyway:

https://github.com/darwin-on-arm/xnu/blob/master/bsd/hfs/hfs.h#L849

/* Maximum extended attribute size supported for all extended attributes except
* resource fork and finder info.
*/
#define HFS_XATTR_MAXSIZE (128 * 1024)

So, I need to check and correct slightly HFS+ xattrs support code.
Because, I used 3082 bytes limitation value. 

Thanks,
Vyacheslav Dubeyko.

> > 
> > The Linux Kernel has a limit imposed to it in include/linux/limits.h
> > 
> >     #defineXATTR_SIZE_MAX 65536   /* size of an extended attribute value
> >     (64k) */
> > 
> >     #defineXATTR_LIST_MAX 65536   /* size of extended attribute namelist
> >     (64k) */
> > 
> 
> Yes, 64k is the VFS limit per EA value size.
> > Changing this values feels unsafe because they will be system wide.
> > 
> > Is the any possibility to combine Linux + XFS to make a backup that
> > works with EA or is this more a question for kernel.org <http://kernel.org>?
> 
> So if an EA value size on HFS+ is larger than 64k, I suspect it would failed to preserve
> on Linux+XFS... But if a file has multiple EAs, and each EA's value size is <= 64K, it
> would be works IMO.
> 
> Thanks,
> -Jeff
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
