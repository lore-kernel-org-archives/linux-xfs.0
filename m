Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D64387F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 23:06:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69CB7AC003
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 21:06:22 -0700 (PDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	InNfuAIJXXd7Qnc1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 21:06:20 -0700 (PDT)
Received: by wibg7 with SMTP id g7so20145145wib.1
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 21:06:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150305131731.GA16235@lst.de>
References: <20150303221033.GB19439@fieldses.org>
	<20150303224456.GV4251@dastard>
	<20150304020826.GD19439@fieldses.org>
	<20150304155421.GE1627@fieldses.org>
	<20150304220900.GX18360@dastard>
	<20150304222709.GI1627@fieldses.org>
	<20150304224557.GY4251@dastard> <54F78BE5.1020608@sandeen.net>
	<20150304225623.GZ4251@dastard>
	<20150305040849.GJ1627@fieldses.org>
	<20150305131731.GA16235@lst.de>
Date: Fri, 20 Mar 2015 12:06:18 +0800
Message-ID: <CAB6yy341fvF8Bsg0_hViQm+zRLVdJ2WOE9duDwdU+S0CkOEpbg@mail.gmail.com>
Subject: Re: panic on 4.20 server exporting xfs filesystem
From: Kinglong Mee <kinglongmee@gmail.com>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Eric Sandeen <sandeen@sandeen.net>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Mar 5, 2015 at 9:17 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Mar 04, 2015 at 11:08:49PM -0500, J. Bruce Fields wrote:
>> Ah-hah:
>>
>>       static void
>>       nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
>>       {
>>               ...
>>               nfsd4_cb_layout_fail(ls);
>>
>> That'd do it!
>>
>> Haven't tried to figure out why exactly that's getting called, and why
>> only rarely.  Some intermittent problem with the callback path, I guess.
>>
>> Anyway, I think that solves most of the mystery....
>
> Ooops, that was a nasty git merge error in the last rebase, see the fix
> below.  But I really wonder if we need to make the usage of pnfs explicit
> after all, othterwise we'll always hand out layouts on any XFS-exported
> filesystems, which can't be used and will eventually need to be recalled.
>
> ---
> From ad592590cce9f7441c3cd21d030f3a986d8759d7 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 5 Mar 2015 06:12:29 -0700
> Subject: nfsd: don't recursively call nfsd4_cb_layout_fail
>
> Due to a merge error when creating c5c707f9 ("nfsd: implement pNFS
> layout recalls"), we recursivelt call nfsd4_cb_layout_fail from itself,
> leading to stack overflows.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/nfsd/nfs4layouts.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
> index 3c1bfa1..1028a06 100644
> --- a/fs/nfsd/nfs4layouts.c
> +++ b/fs/nfsd/nfs4layouts.c
> @@ -587,8 +587,6 @@ nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
>
>         rpc_ntop((struct sockaddr *)&clp->cl_addr, addr_str, sizeof(addr_str));
>
> -       nfsd4_cb_layout_fail(ls);
> -

Maybe you want adding "trace_layout_recall_fail(&ls->ls_stid.sc_stateid);" here?
I think the following is better,

@@ -587,7 +587,7 @@ nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)

        rpc_ntop((struct sockaddr *)&clp->cl_addr, addr_str, sizeof(addr_str));

-       nfsd4_cb_layout_fail(ls);
+       trace_layout_recall_fail(&ls->ls_stid.sc_stateid);

        printk(KERN_WARNING
                "nfsd: client %s failed to respond to layout recall. "

thanks,
Kinglong Mee

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
