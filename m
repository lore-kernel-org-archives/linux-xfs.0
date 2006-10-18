Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Oct 2006 17:57:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9I0vVaG002310
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 17:57:33 -0700
Date: Wed, 18 Oct 2006 10:56:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] Make stuff static
Message-ID: <20061018005640.GS11034@melbourne.sgi.com>
References: <20060929032856.8DA9C18001A5E@sandeen.net> <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local> <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net> <20061016232250.GM11034@melbourne.sgi.com> <1161042943.5723.117.camel@xenon.msp.redhat.com> <20061017005038.GN11034@melbourne.sgi.com> <45342BF3.8020609@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45342BF3.8020609@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Russell Cattelan <cattelan@thebarn.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Mon, Oct 16, 2006 at 08:03:47PM -0500, Eric Sandeen wrote:
> David Chinner wrote:
> 
> >>So you are proposing?
> >>/* non-debug */
> >>#define STATIC static inline
> >>/* debug */
> >>#define STATIC noinline
> >
> >No.
> >
> >Currently STATIC is defined in fs/xfs/support/debug.h as:
> >
> >#ifndef STATIC
> >#define STATIC static
> >#endif
> >
> >I'm proposing that gets changed to:
> >
> >>#define STATIC static noinline

This has a pretty big effect on stack usage. These numbers are from
an x86_64 build. A negative diff means the function uses more stack
space than before (probably a function that was getting inlined):


      Function                  OLD      NEW     DIFF
      ------------------------  ---      ---     ----
                  xfs_vn_mknod  616      200      416
                     xfs_ioctl  440      <100      340
              xfs_inobt_insert  328      <100      228
               xfs_bmbt_insert  312      <100      212
                xfs_vn_symlink  376      168      208
                   xfs_dialloc  360      152      208
                     xfs_bmapi  552      344      208
                   xfs_symlink  280      <100      180
         xfs_change_file_space  376      200      176
                     xfs_write  264      <100      164
                  xfs_bulkstat  264      <100      164
        xfs_page_state_convert  344      184      160
                   xfs_bunmapi  376      216      160
                     xfs_ifree  248      <100      148
           xfs_bmap_add_extent  280      136      144
                   xfs_getbmap  232      <100      132
               xfs_attr_remove  232      <100      132
        xfs_iomap_write_direct  216      <100      116
                xfs_fs_cmn_err  216      <100      116
               xfs_bmbt_delete  216      <100      116
         xfs_bmap_add_attrfork  216      <100      116
                  xfs_attr_set  216      <100      116
                   xfs_cmn_err  208      <100      108
      xfs_iomap_write_allocate  200      <100      100
                  xfs_inactive  200      <100      100
     xfs_bmap_extents_to_btree  200      <100      100
              xfs_alloc_insert  200      <100      100
                   xfs_setattr  184      <100      84
                     xfs_mkdir  184      <100      84
              xfs_inobt_delete  184      <100      84
           xfs_dir2_grow_inode  184      <100      84
                    xfs_create  184      <100      84
xfs_bmap_add_extent_unwritten_real  184      <100      84
          xfs_alloc_file_space  184      <100      84
              xfs_alloc_delete  184      <100      84
                 xfs_qm_dqtobp  248      168      80
                 xfs_vn_unlink  168      <100      68
                xfs_vn_setattr  168      <100      68
                  xfs_vn_rmdir  168      <100      68
                 xfs_vn_rename  168      <100      68
         xfs_rtallocate_extent  168      <100      68
             xfs_probe_cluster  168      <100      68
                 xfs_da_do_buf  168      <100      68
    xfs_attr_shortform_to_leaf  168      <100      68
        xfs_alloc_fix_freelist  168      <100      68
             xfs_acl_allow_set  168      <100      68
       xfs_attrmulti_by_handle  168      104      64
                   xfs_vn_link  160      <100      60
                xfs_acl_vtoacl  160      <100      60
                  xfs_acl_vget  160      <100      60
               xfs_acl_setmode  160      <100      60
                  xfs_readlink  152      <100      52
                      xfs_link  152      <100      52
     xfs_iomap_write_unwritten  152      <100      52
           xfs_growfs_rt_alloc  152      <100      52
               xfs_dir_replace  152      <100      52
            xfs_dir_removename  152      <100      52
                xfs_dir_lookup  152      <100      52
            xfs_dir_createname  152      <100      52
        xfs_dir2_leaf_getdents  152      <100      52
           xfs_da_shrink_inode  152      <100      52
             xfs_da_grow_inode  152      <100      52
          xfs_corruption_error  152      <100      52
                  xfs_zero_eof  168      120      48
                 xfs_growfs_rt  168      120      48
                xfs_trans_init  144      <100      44
              xfs_dir_canenter  144      <100      44
                    xfs_remove  136      <100      36
               xfs_growfs_data  136      <100      36
             xfs_fs_fill_super  136      <100      36
                  xfs_dir_init  136      <100      36
         xfs_dir2_node_addname  136      <100      36
              xfs_bmbt_newroot  136      <100      36
     xfs_bmap_local_to_extents  136      <100      36
           xfs_attr_rmtval_set  136      <100      36
           xfs_attr_rmtval_get  136      <100      36
    xfs_attr_leaf_to_shortform  136      <100      36
        xfs_attr_leaf_inactive  136      <100      36
         xfs_iomap_write_delay  296      264      32
      xfs_zero_remaining_bytes  120      <100      20
xfs_trans_unreserve_and_mod_sb  120      <100      20
                     xfs_rmdir  120      <100      20
         xfs_log_unmount_write  120      <100      20
               xfs_free_extent  120      <100      20
              xfs_file_readdir  120      <100      20
                xfs_dir_ialloc  120      <100      20
          xfs_dir2_sf_to_block  120      <100      20
       xfs_dir2_block_getdents  120      <100      20
                    xfs_difree  120      <100      20
 xfs_bmap_add_extent_hole_real  120      <100      20
              xfs_alloc_rshift  120      <100      20
             _xfs_trans_commit  328      312      16
                    xfs_rename  248      232      16
              xfs_qm_dqiterate  136      120      16
                   xfs_mountfs  136      120      16
                     xfs_iomap  152      136      16
                xfs_attr_fetch  168      152      16
                   init_xfs_fs  112      <100      12
              xfs_vm_direct_IO  104      <100      4
          xfs_itruncate_finish  104      <100      4
                  xfs_inumbers  104      <100      4
              xfs_inobt_rshift  104      <100      4
                    xfs_iflush  104      <100      4
      xfs_dir2_node_removename  104      <100      4
     xfs_dir2_leafn_lookup_int  104      <100      4
         xfs_dir2_leaf_addname  104      <100      4
                  xfs_dilocate  104      <100      4
          xfs_bmap_last_before  104      <100      4
           xfs_attr_leaf_split  104      <100      4
    xfs_rtallocate_extent_size  <100      104      -4
         xfs_fssetdm_by_handle  <100      104      -4
xfs_bmap_add_extent_hole_delay  <100      104      -4
       xfs_attr_leaf_freextent  <100      104      -4
           xfs_zero_last_block  <100      120      -20
    xfs_rtallocate_extent_near  <100      120      -20
         xfs_ioc_fsgeometry_v1  <100      120      -20
            xfs_ioc_fsgeometry  <100      120      -20
        xfs_attrlist_by_handle  <100      120      -20
              xfs_alloc_insrec  <100      120      -20
                xfs_qm_dqalloc  <100      136      -36
              xfs_inobt_insrec  <100      136      -36
                  xfs_hex_dump  <100      136      -36
   xfs_bmap_add_attrfork_local  <100      136      -36
        xfs_readlink_by_handle  <100      152      -52
               xfs_bmbt_insrec  <100      152      -52
      xfs_inactive_symlink_rmt  <100      168      -68
             xfs_cluster_write  <100      168      -68
              xfs_alloc_delrec  <100      168      -68
           xfs_ialloc_ag_alloc  <100      184      -84
           xfs_attr_remove_int  <100      184      -84
               xfs_inobt_split  <100      200      -100
             xfs_inobt_newroot  <100      200      -100
              xfs_inobt_delrec  <100      200      -100
           xfs_free_file_space  <100      200      -100
                xfs_bmbt_split  <100      200      -100
               xfs_bmbt_delrec  <100      200      -100
xfs_bmap_add_extent_delay_real  <100      200      -100
              xfs_attr_set_int  <100      200      -100
             xfs_cleanup_inode  <100      208      -108
           xfs_bmap_del_extent  <100      216      -116
              xfs_bmap_btalloc  <100      216      -116
               xfs_find_handle  <100      248      -148

So this may help a lot with stack usage, but what it does to performance
will be an interesting question....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
