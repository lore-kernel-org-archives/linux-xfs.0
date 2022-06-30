Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C95C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 19:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiF3TTN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 15:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbiF3TTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 15:19:12 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EEF427EB
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 12:19:10 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id p31so671475qvp.5
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 12:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=BP53oOVU/SW52VnW5PrpOkvdRjSTm4DgQtRWXO539nw=;
        b=efwFCTH8zfkLgPHwPEn3qgtQWWMGIMNh4emyMJMy8cl6Xtrdeaq9DuqJEamOFKGvCN
         Aat8J/pxT5GKpwzXPg7MxDKbt2YeXXqohBSDfC5+/8liDNthM06py11yR7vAGo2tXO1/
         loPD5N/6GPM34q2CRX1K6rvfr5v1rDHqc51KS9KJQ6lnDMjk/rkOuaj5ZdhQ2VDgTLdo
         aP8WcaIEk+IAiI0ay8uT3K5vpYONT2/OZBdspRP3priL05W3WUwTBpE7b5u3laynjTEr
         nR4Ag8D6UO6bv890w9ycxrvd3gkXDar12avoR7ajackcS/YbODB1qTpf4XT903a7nnUu
         GGcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=BP53oOVU/SW52VnW5PrpOkvdRjSTm4DgQtRWXO539nw=;
        b=aIniXdeXJDkrkI2+WDPpFjzd/ZVIuHQTZOo8XdrPd6H8NFPiWqYZ82+0U8aC/o3a/S
         2Kn7LPaX13aXhkl+wnxk3I8WVymsB86hOX02VLRU+UIohoc0Zgd+2woF4rybMqO0hN+3
         s8WNeXAc+Rnv/HKvu4O8alH5OA4dQW1JBc6QGh4EkB7qRfSXQa/ZGeB0oxexDP1AhzjY
         nXfQ9xaahz87QCk6Or8vlT8UTVEUgNpFQr+TigGIQqmsAqeNfOTSHugxxF+mQAFJq0B8
         9LK5qYaCmjc0Gu51Rb96iesGvHbZMw/1gKmoTsbcPJq3M1OWr6+NUYh2ODETH+I2V9CG
         qu+A==
X-Gm-Message-State: AJIora8+iwXY/XC0JeuBzx8+ACMVUK7iQaWH0ZRvzs/FAFepuA5JEM9Y
        UdpVYvREmXfkCTSglV+FM+U=
X-Google-Smtp-Source: AGRyM1tMNX7xFoq7fAUB3eCR1Yj33ZkPbHClaWi3gyrlu2nIIKO40EGCOQ711CUExEgKhfiUNDflag==
X-Received: by 2002:a05:6214:1c83:b0:46b:a79a:2f0b with SMTP id ib3-20020a0562141c8300b0046ba79a2f0bmr14130316qvb.103.1656616749682;
        Thu, 30 Jun 2022 12:19:09 -0700 (PDT)
Received: from ?IPV6:2601:18f:801:dd40:c38c:a019:12ef:edc9? ([2601:18f:801:dd40:c38c:a019:12ef:edc9])
        by smtp.gmail.com with ESMTPSA id o16-20020a05620a2a1000b006a68fdc2d18sm12092696qkp.130.2022.06.30.12.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 12:19:08 -0700 (PDT)
Message-ID: <e61ae295-a331-d36a-cae1-646022dc2a6e@gmail.com>
Date:   Thu, 30 Jun 2022 15:19:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v2] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Content-Language: en-US
From:   Hironori Shiina <shiina.hironori@gmail.com>
To:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Donald Douwsma <ddouwsma@redhat.com>
References: <20201113125127.966243-1-hsiangkao@redhat.com>
 <20201116080723.1486270-1-hsiangkao@redhat.com>
 <aed54ce4-e1bf-39f7-cf91-a67e29f59d52@gmail.com>
In-Reply-To: <aed54ce4-e1bf-39f7-cf91-a67e29f59d52@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/10/22 19:05, Hironori Shiina wrote:
> 
> 
> On 11/16/20 03:07, Gao Xiang wrote:
>> If rootino is wrong and misspecified to a subdir inode #,
>> the following assertion could be triggered:
>>   assert(ino != persp->p_rootino || hardh == persp->p_rooth);
>>
>> This patch adds a '-x' option (another awkward thing is that
>> the codebase doesn't support long options) to address
>> problamatic images by searching for the real dir, the reason
>> that I don't enable it by default is that I'm not very confident
>> with the xfsrestore codebase and xfsdump bulkstat issue will
>> also be fixed immediately as well, so this function might be
>> optional and only useful for pre-exist corrupted dumps.
> 
> I agree that this function is optional for another reason. This fix
> cannot be the default behavior because of a workaround for a case where
> a fake root's gen is zero. This workaround prevents a correct dump
> without a fake root from being restored.
> 
>>
>> In details, my understanding of the original logic is
>>  1) xfsrestore will create a rootdir node_t (p_rooth);
>>  2) it will build the tree hierarchy from inomap and adopt
>>     the parent if needed (so inodes whose parent ino hasn't
>>     detected will be in the orphan dir, p_orphh);
>>  3) during this period, if ino == rootino and
>>     hardh != persp->p_rooth (IOWs, another node_t with
>>     the same ino # is created), that'd be definitely wrong.
>>
>> So the proposal fix is that
>>  - considering the xfsdump root ino # is a subdir inode, it'll
>>    trigger ino == rootino && hardh != persp->p_rooth condition;
>>  - so we log this node_t as persp->p_rooth rather than the
>>    initial rootdir node_t created in 1);
>>  - we also know that this node is actually a subdir, and after
>>    the whole inomap is scanned (IOWs, the tree is built),
>>    the real root dir will have the orphan dir parent p_orphh;
>>  - therefore, we walk up by the parent until some node_t has
>>    the p_orphh, so that's it.
>>
>> Cc: Donald Douwsma <ddouwsma@redhat.com>
>> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
>> ---
>> changes since RFC v1:
>>  - fix non-dir fake rootino cases since tree_begindir()
>>    won't be triggered for these non-dir, and we could do
>>    that in tree_addent() instead (fault injection verified);
>>
>>  - fix fake rootino case with gen = 0 as well, for more
>>    details, see the inlined comment in link_hardh()
>>    (fault injection verified as well).
>>
>> Anyway, all of this behaves like a workaround and I have
>> no idea how to deal it more gracefully.
>>
>>  restore/content.c |  7 +++++
>>  restore/getopt.h  |  4 +--
>>  restore/tree.c    | 70 ++++++++++++++++++++++++++++++++++++++++++++---
>>  restore/tree.h    |  2 ++
>>  4 files changed, 77 insertions(+), 6 deletions(-)
>>
>> diff --git a/restore/content.c b/restore/content.c
>> index 6b22965..e807a83 100644
>> --- a/restore/content.c
>> +++ b/restore/content.c
>> @@ -865,6 +865,7 @@ static int quotafilecheck(char *type, char *dstdir, char *quotafile);
>>  
>>  bool_t content_media_change_needed;
>>  bool_t restore_rootdir_permissions;
>> +bool_t need_fixrootdir;
>>  char *media_change_alert_program = NULL;
>>  size_t perssz;
>>  
>> @@ -964,6 +965,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>>  	stsz = 0;
>>  	interpr = BOOL_FALSE;
>>  	restore_rootdir_permissions = BOOL_FALSE;
>> +	need_fixrootdir = BOOL_FALSE;
>>  	optind = 1;
>>  	opterr = 0;
>>  	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
>> @@ -1189,6 +1191,9 @@ content_init(int argc, char *argv[], size64_t vmsz)
>>  		case GETOPT_FMT2COMPAT:
>>  			tranp->t_truncategenpr = BOOL_TRUE;
>>  			break;
>> +		case GETOPT_FIXROOTDIR:
>> +			need_fixrootdir = BOOL_TRUE;
>> +			break;
>>  		}
>>  	}
>>  
>> @@ -3140,6 +3145,8 @@ applydirdump(drive_t *drivep,
>>  			return rv;
>>  		}
>>  
>> +		if (need_fixrootdir)
>> +			tree_fixroot();
>>  		persp->s.dirdonepr = BOOL_TRUE;
>>  	}
>>  
>> diff --git a/restore/getopt.h b/restore/getopt.h
>> index b5bc004..b0c0c7d 100644
>> --- a/restore/getopt.h
>> +++ b/restore/getopt.h
>> @@ -26,7 +26,7 @@
>>   * purpose is to contain that command string.
>>   */
>>  
>> -#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wABCDEFG:H:I:JKL:M:NO:PQRS:TUVWX:Y:"
>> +#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wxABCDEFG:H:I:JKL:M:NO:PQRS:TUVWX:Y:"
>>  
>>  #define GETOPT_WORKSPACE	'a'	/* workspace dir (content.c) */
>>  #define GETOPT_BLOCKSIZE        'b'     /* blocksize for rmt */
>> @@ -51,7 +51,7 @@
>>  /*				'u' */
>>  #define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4) */
>>  #define	GETOPT_SMALLWINDOW	'w'	/* use a small window for dir entries */
>> -/*				'x' */
>> +#define GETOPT_FIXROOTDIR	'x'	/* try to fix rootdir due to bulkstat misuse */
>>  /*				'y' */
>>  /*				'z' */
>>  #define	GETOPT_NOEXTATTR	'A'	/* do not restore ext. file attr. */
>> diff --git a/restore/tree.c b/restore/tree.c
>> index 0670318..918fa01 100644
>> --- a/restore/tree.c
>> +++ b/restore/tree.c
>> @@ -15,7 +15,6 @@
>>   * along with this program; if not, write the Free Software Foundation,
>>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>   */
>> -
>>  #include <stdio.h>
>>  #include <unistd.h>
>>  #include <stdlib.h>
>> @@ -265,6 +264,7 @@ extern void usage(void);
>>  extern size_t pgsz;
>>  extern size_t pgmask;
>>  extern bool_t restore_rootdir_permissions;
>> +extern bool_t need_fixrootdir;
>>  
>>  /* forward declarations of locally defined static functions ******************/
>>  
>> @@ -331,10 +331,45 @@ static tran_t *tranp = 0;
>>  static char *persname = PERS_NAME;
>>  static char *orphname = ORPH_NAME;
>>  static xfs_ino_t orphino = ORPH_INO;
>> +static nh_t orig_rooth = NH_NULL;
>>  
>>  
>>  /* definition of locally defined global functions ****************************/
>>  
>> +void
>> +tree_fixroot(void)
>> +{
>> +	nh_t		rooth = persp->p_rooth;
>> +	xfs_ino_t 	rootino;
>> +
>> +	while (1) {
>> +		nh_t	parh;
>> +		node_t *rootp = Node_map(rooth);
>> +
>> +		rootino = rootp->n_ino;
>> +		parh = rootp->n_parh;
>> +		Node_unmap(rooth, &rootp);
>> +
>> +		if (parh == rooth ||
>> +		/*
>> +		 * since all new node (including non-parent)
>> +		 * would be adopted into orphh
>> +		 */
>> +		    parh == persp->p_orphh ||
>> +		    parh == NH_NULL)
>> +			break;
>> +		rooth = parh;
>> +	}
>> +
>> +	if (rooth != persp->p_rooth) {
>> +		persp->p_rooth = rooth;
>> +		persp->p_rootino = rootino;
>> +
> 
> As far as I see intialization for a root in tree_init(), isn't it
> necessary to adopt the orphanage node(persp->p_orphh) to the new root?
> 

These two steps are necessary here:
+               disown(rooth);
+               adopt(persp->p_rooth, persp->p_orphh, NH_NULL);

Otherwise, we hit an assertion error when restroing a renamed file in
the cumulative mode. We need to re-adopt the orphanage dir to the fixed
root for creating a correct path of a node put to orphanage here:

https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/tree/restore/tree.c#n1498

>> +		mlog(MLOG_NORMAL, _("fix root # to %llu (bind mount?)\n"),
>> +		     rootino);
>> +	}
>> +}
>> +
>>  /* ARGSUSED */
>>  bool_t
>>  tree_init(char *hkdir,
>> @@ -754,7 +789,8 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>>  	/* lookup head of hardlink list
>>  	 */
>>  	hardh = link_hardh(ino, gen);
>> -	assert(ino != persp->p_rootino || hardh == persp->p_rooth);
>> +	if (need_fixrootdir == BOOL_FALSE)
>> +		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
>>  
>>  	/* already present
>>  	 */
>> @@ -823,7 +859,6 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>>  		adopt(persp->p_orphh, hardh, NRH_NULL);
>>  		*dahp = dah;
>>  	}
>> -
>>  	return hardh;
>>  }
>>  
>> @@ -968,6 +1003,7 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
>>  				}
>>  			} else {
>>  				assert(hardp->n_nrh != NRH_NULL);
>> +
>>  				namebuflen
>>  				=
>>  				namreg_get(hardp->n_nrh,
>> @@ -1118,6 +1154,13 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
>>  		      ino,
>>  		      gen);
>>  	}
>> +	/* found the fake rootino from subdir, need fix p_rooth. */
>> +	if (need_fixrootdir == BOOL_TRUE &&
>> +	    persp->p_rootino == ino && hardh != persp->p_rooth) {
>> +		mlog(MLOG_NORMAL,
>> +		     _("found fake rootino #%llu, will fix.\n"), ino);
>> +		persp->p_rooth = hardh;
>> +	}
>>  	return RV_OK;
>>  }
>>  
>> @@ -3841,7 +3884,26 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
>>  static nh_t
>>  link_hardh(xfs_ino_t ino, gen_t gen)
>>  {
>> -	return hash_find(ino, gen);
>> +	nh_t tmp = hash_find(ino, gen);
>> +
>> +	/*
>> +	 * XXX (another workaround): the simply way is that don't reuse node_t
>> +	 * with gen = 0 created in tree_init(). Otherwise, it could cause
>> +	 * xfsrestore: tree.c:1003: tree_addent: Assertion
>> +	 * `hardp->n_nrh != NRH_NULL' failed.
>> +	 * and that node_t is a dir node but the fake rootino could be a non-dir
>> +	 * plus reusing it could cause potential loop in tree hierarchy.
>> +	 */
>> +	if (need_fixrootdir == BOOL_TRUE &&
>> +	    ino == persp->p_rootino && gen == 0 &&
>> +	    orig_rooth == NH_NULL) {
> 
> As I mentioned above, this workaround makes this correction optional.
> This workaround assumes the initially created root is fake. If a dump is
> created correctly without a fake root, this function returns NH_NULL for
> the correct root.
> 
> 

Due to this part, '-x' flag does not work for the correct dump. We need
to provide procudure for a user who may have a wrong dump with man or
the help message like this:
---------
A user who has a dump created by xfsdump with this bug should see a
table of contents of the dump file before restoring:
  xfsrestore -t -f <dumpfile>
If a similar message to the following one is displayed, '-x' is required
to restore the dump:
  NOTE: ino 128 salvaging file, placing in orphanage/1024.0/FILE_056
Otherwise, '-x' is not required.
---------

I tried the cumulative mode locally with this fix by combining xfs/064,
xfs/065 and xfs/545 in xfstests. Then, the issue regarding a renamed
file, which is mentioned above, was found. Based on the results of the
tests, the following information also should be provied to users:
---------
In the cumulative mode, a user needs to check with '-t' and use '-x'
flag only for the level 0 dump. Once the root is fixed in restoring the
level 0 dump, '-x' flag is no longer required for level 1+ dumps.
---------

Thanks,
Hironori

> Thanks,
> Hironori
> 
>> +		mlog(MLOG_NORMAL,
>> +_("link out fake rootino %llu with gen=0 created in tree_init()\n"), ino);
>> +		link_out(tmp);
>> +		orig_rooth = tmp;
>> +		return NH_NULL;
>> +	}
>> +	return tmp;
>>  }
>>  
>>  /* returns following node in hard link list
>> diff --git a/restore/tree.h b/restore/tree.h
>> index 4f9ffe8..5d0c346 100644
>> --- a/restore/tree.h
>> +++ b/restore/tree.h
>> @@ -18,6 +18,8 @@
>>  #ifndef TREE_H
>>  #define TREE_H
>>  
>> +void tree_fixroot(void);
>> +
>>  /* tree_init - creates a new tree abstraction.
>>   */
>>  extern bool_t tree_init(char *hkdir,
