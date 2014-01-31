Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 317557F75
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 06:52:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 22F958F804B
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 04:52:20 -0800 (PST)
Received: from gproxy5-pub.mail.unifiedlayer.com
	(gproxy5-pub.mail.unifiedlayer.com [67.222.38.55]) by
	cuda.sgi.com with SMTP id 65lmOEZ056bc7aRX for
	<xfs@oss.sgi.com>; Fri, 31 Jan 2014 04:52:18 -0800 (PST)
Message-ID: <1391172723.4275.11.camel@ubuntu>
Subject: Re: Extended attributes limit in Linux
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Date: Fri, 31 Jan 2014 16:52:03 +0400
In-Reply-To: <52EB960D.607@oracle.com>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>
	<52EB64DC.4020603@oracle.com> <1391165083.4275.7.camel@ubuntu>
	<52EB960D.607@oracle.com>
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

On Fri, 2014-01-31 at 20:24 +0800, Jeff Liu wrote:
> On 01/31 2014 18:44 PM, Vyacheslav Dubeyko wrote:
> > On Fri, 2014-01-31 at 16:54 +0800, Jeff Liu wrote:
> >> Hello,
> >>
> >> On 01/31 2014 15:40 PM, Sun_Blood wrote:
> >>> Hello,
> >>>
> >>> If I understands it correctly XFS don't have a limit to the size of
> >>> extended attributes(EA) but Linux impose a limit at 64k.
> >>> What I am trying to do is build a backup server that our Apple computers
> >>> will use together with rsync to backup files to. The problem I face is
> >>> that Apple HFS+ don't have a limit to EA so it has files with more then
> >>> 64k of EA in it.
> > 
> > Technical Note TN1150:
> > "In an HFS Plus B-tree, the node size is determined by a field
> > (nodeSize) in the header node. The node size must be a power from 512
> > through 32,768."
> > 
> > So, as minimum, xattrs unable to be a larger than node size.
> > 
> > But xattrs' size has limitation anyway:
> > 
> > https://github.com/darwin-on-arm/xnu/blob/master/bsd/hfs/hfs.h#L849
> > 
> > /* Maximum extended attribute size supported for all extended attributes except
> > * resource fork and finder info.
> > */
> > #define HFS_XATTR_MAXSIZE (128 * 1024)
> > 
> > So, I need to check and correct slightly HFS+ xattrs support code.
> > Because, I used 3082 bytes limitation value.
> 
> I just verified above limits on Mac OS X, that's true.
> 
> sh-3.2# a=`perl -e 'print "A"x131072'`
> sh-3.2# xattr -w user.comment ${a} xattr_test
> 
> sh-3.2# a=`perl -e 'print "A"x131073'`
> sh-3.2# xattr -w user.comment ${a} xattr_test
> xattr: [Errno 7] Argument list too long: 'xattr'
> 
> Hence, that would be a problem to preserve EA with large value size on Linux.
> 

I checked the same under Mac OS X 10.6.8 (Snow Leopard). And I have
failed on 3803 bytes size of xattr. So, I suppose that you have Mac OS X
Lion. And EAs is larger under Lion yet.

What version of Mac OS X have you?

Thanks,
Vyacheslav Dubeyko.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
