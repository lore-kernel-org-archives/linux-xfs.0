Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA2CD7F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 16:16:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C8CC48F8068
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 14:16:09 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id wxJdrFXpPsucDQ4u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 14:16:08 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 17 May 2013 15:16:08 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 9A74B3E4004E
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 15:15:49 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r4HLFrMp135552 for <xfs@oss.sgi.com>; Fri, 17 May 2013 15:15:53 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r4HLFquP031121
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 15:15:53 -0600
Subject: Re: [PATCH v8 2/5] xfs: Add pquota fields where gquota is used.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <51906528.3030307@oracle.com>
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-3-git-send-email-sekharan@us.ibm.com>
	<51906528.3030307@oracle.com>
Date: Fri, 17 May 2013 16:15:44 -0500
Message-ID: <1368825344.10223.30.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Cc: xfs@oss.sgi.com

On Mon, 2013-05-13 at 11:59 +0800, Jeff Liu wrote:
> Hi,
> 
> On 05/11/2013 05:21 AM, Chandra Seetharaman wrote:
> > Add project quota changes to all the places where group quota field
> > is used:
> >    * add separate project quota members into various structures
> >    * split project quota and group quotas so that instead of overriding
> >      the group quota members incore, the new project quota members are
> >      used instead
> >    * get rid of usage of the OQUOTA flag incore, in favor of separate
> >    * group
> >      and project quota flags.
> >    * add a project dquot argument to various functions.
> > 
> > No externally visible interfaces changed.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

<snip>

> > @@ -409,7 +421,10 @@ xfs_qm_dqattach_one(
> >  		 * be reclaimed as long as we have a ref from inode and we
> >  		 * hold the ilock.
> >  		 */
> > -		dqp = udqhint->q_gdquot;
> > +		if (type == XFS_DQ_GROUP)
> > +			dqp = udqhint->q_gdquot;
> > +		else
> > +			dqp = udqhint->q_pdquot;
> Maybe it's better to:
> dqp = "type == XFS_DQ_GROUP" ? udqhint->q_gdquot :
> 			       udqhint->q_pdquot;

Jeff,

"if else" construct is preferred for readability than "? :" construct.

So, I am leaving it as is.


<snip>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
